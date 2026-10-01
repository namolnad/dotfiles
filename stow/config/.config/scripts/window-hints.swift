// Vimium-style letters over AeroSpace windows, after Vimarchy
// (github.com/clickety-clacks/vimarchy).
//
// window-hints focus (alt-w) letters every window on a visible workspace:
//
//   tap a letter    focus that window
//   double-tap      focus it and toggle fullscreen
//   hold            pick it up, then tap another window's letter to swap the
//                   two (tiled windows on the same workspace)
//   shift+letter    open a ring of workspaces around it, keyed like the
//                   alt-<key> bindings: tap one to take the window there, or
//                   shift+tap to send it there and stay
//
// window-hints swap (alt-shift-w) letters the other tiled windows on the
// focused workspace, and pressing one swaps the focused window with it.
//
// Esc, any other letter, a click, switching apps, or ten seconds put the
// letters away, and running the same mode again toggles them off. --dry-run
// prints what the letters would do instead. aerospace.toml binds alt-w and
// alt-shift-w to window-hints.sh, which compiles this file.
//
// AeroSpace has no plugin API, so this works like the other scripts here: it
// reads windows from the aerospace CLI and acts through it. The letter keys are
// taken as Carbon hotkeys, the same mechanism as AeroSpace's binding modes, so
// no app loses focus and no Accessibility permission is needed; they are
// released when the process exits. AeroSpace window ids are CGWindowIDs, so
// CoreGraphics supplies the frames.

import AppKit
import Carbon.HIToolbox

enum Mode: String { case focus, swap }

/// Home row first, as Vimarchy does.
let letters = Array("asdfghjklqwertyuiopzxcvbnm")

/// Vimarchy's timings.
let holdDelay: TimeInterval = 0.35
let doubleTapWindow: TimeInterval = 0.28

/// Letters left up swallow those keys everywhere, so they do not stay long.
let dismissAfter: TimeInterval = 10

// MARK: - AeroSpace

let aerospacePath = ["/opt/homebrew/bin/aerospace", "/usr/local/bin/aerospace"]
    .first { FileManager.default.isExecutableFile(atPath: $0) } ?? "/opt/homebrew/bin/aerospace"

/// Starts `aerospace args`; the returned closure waits for it and gives its
/// output, or nil if it failed. Starting several before waiting overlaps them.
func startAerospace(_ args: [String]) -> () -> String? {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: aerospacePath)
    process.arguments = args
    let output = Pipe()
    process.standardOutput = output
    process.standardError = FileHandle.nullDevice
    guard (try? process.run()) != nil else { return { nil } }
    return {
        let data = output.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        return process.terminationStatus == 0 ? String(decoding: data, as: UTF8.self) : nil
    }
}

@discardableResult
func aerospace(_ args: String...) -> String? { startAerospace(args)() }

struct Window {
    let id: CGWindowID
    let app: String
    let pid: pid_t
    let workspace: String
    let tiled: Bool
    let focused: Bool
    /// Orientation of the workspace's root container.
    let rootHorizontal: Bool
    /// CoreGraphics coordinates: origin at the top left of the main display.
    let frame: CGRect
}

/// A window and the letter over it.
struct Pick {
    let letter: Character
    let window: Window
}

/// The on-screen windows of visible workspaces, left to right.
func visibleWindows() -> [Window] {
    struct Listed: Decodable {
        let id: CGWindowID, app: String, pid: pid_t, workspace: String, layout: String, rootLayout: String
        enum CodingKeys: String, CodingKey {
            case id = "window-id", app = "app-name", pid = "app-pid", workspace
            case layout = "window-layout", rootLayout = "workspace-root-container-layout"
        }
    }
    let listing = startAerospace([
        "list-windows", "--workspace", "visible", "--json", "--format",
        "%{window-id}%{app-name}%{app-pid}%{workspace}%{window-layout}%{workspace-root-container-layout}",
    ])
    let focusedListing = startAerospace(["list-windows", "--focused", "--format", "%{window-id}"])
    let frames = onscreenFrames()
    guard let json = listing(),
          let listed = try? JSONDecoder().decode([Listed].self, from: Data(json.utf8)) else { return [] }
    let focusedId = focusedListing().flatMap { CGWindowID($0.trimmingCharacters(in: .whitespacesAndNewlines)) }

    return listed
        .compactMap { w in
            frames[w.id].map { frame in
                Window(id: w.id, app: w.app, pid: w.pid, workspace: w.workspace,
                       tiled: w.layout.hasSuffix("_tiles") || w.layout.hasSuffix("_accordion"),
                       focused: w.id == focusedId, rootHorizontal: w.rootLayout.hasPrefix("h_"), frame: frame)
            }
        }
        .sorted { ($0.frame.minX, $0.frame.minY, $0.id) < ($1.frame.minX, $1.frame.minY, $1.id) }
}

func onscreenFrames() -> [CGWindowID: CGRect] {
    let info = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
        as? [[String: Any]] ?? []
    var frames: [CGWindowID: CGRect] = [:]
    for window in info {
        if let id = window[kCGWindowNumber as String] as? CGWindowID,
           let bounds = window[kCGWindowBounds as String] as? NSDictionary,
           let frame = CGRect(dictionaryRepresentation: bounds) {
            frames[id] = frame
        }
    }
    return frames
}

/// Starts reading which workspace each alt-<letter> binding of the current mode
/// switches to, so the ring uses the same keys, in the same context (P-B or
/// W-B), as switching does. The closure waits for the answer.
func startReadingWorkspaceKeys() -> () -> [Character: String] {
    let currentMode = startAerospace(["list-modes", "--current"])
    let modes = startAerospace(["config", "--get", "mode", "--json"])
    return {
        let mode = currentMode()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "main"
        let config = modes().flatMap { try? JSONSerialization.jsonObject(with: Data($0.utf8)) } as? [String: Any]
        let bindings = (config?[mode] as? [String: Any])?["binding"] as? [String: Any] ?? [:]
        var keys: [Character: String] = [:]
        for (binding, command) in bindings {
            let words = (command as? String)?.split(separator: " ") ?? []
            if binding.count == 5, binding.hasPrefix("alt-"), let key = binding.last, key.isLetter,
               words.count == 2, words[0] == "workspace" {
                keys[key] = String(words[1])
            }
        }
        return keys
    }
}

// MARK: - Swapping

/// `swap` only trades a window with its neighbour in AeroSpace's depth-first
/// order, which AeroSpace does not print. With normalization on, containers
/// alternate orientation from the root down, so the frames give it back: split
/// the windows into columns (or rows) that do not overlap, then split each of
/// those the other way. Nil when they do not split cleanly, as in an accordion.
func dfsOrder(_ windows: [Window], horizontal: Bool, flipped: Bool = false) -> [Window]? {
    if windows.count < 2 { return windows }
    func span(_ w: Window) -> (start: CGFloat, end: CGFloat) {
        horizontal ? (w.frame.minX, w.frame.maxX) : (w.frame.minY, w.frame.maxY)
    }
    var groups: [[Window]] = []
    var end = -CGFloat.infinity
    for window in windows.sorted(by: { span($0).start < span($1).start }) {
        if span(window).start >= end - 1 { groups.append([window]) } else { groups[groups.count - 1].append(window) }
        end = max(end, span(window).end)
    }
    // A container whose only child is a container splits the other way.
    if groups.count == 1 { return flipped ? nil : dfsOrder(windows, horizontal: !horizontal, flipped: true) }

    var order: [Window] = []
    for group in groups {
        guard let inner = dfsOrder(group, horizontal: !horizontal) else { return nil }
        order += inner
    }
    return order
}

/// Who a window can swap with, and AeroSpace's order to walk them in.
struct SwapPlan {
    let targets: [Pick]
    let order: [CGWindowID]
}

/// The other tiled windows on `source`'s workspace. Nil when there are none,
/// or when the layout cannot be read.
func swapPlan(for source: Window, windows: [Window], picks: [Pick]) -> SwapPlan? {
    let tiled = windows.filter { $0.tiled && $0.workspace == source.workspace }
    guard source.tiled, let order = dfsOrder(tiled, horizontal: source.rootHorizontal)?.map(\.id) else { return nil }
    let targets = picks.filter { order.contains($0.window.id) && $0.window.id != source.id }
    return targets.isEmpty ? nil : SwapPlan(targets: targets, order: order)
}

struct SwapStep {
    let window: CGWindowID
    let forward: Bool
    var command: String { "swap --window-id \(window) \(forward ? "dfs-next" : "dfs-prev")" }
    var inverse: SwapStep { SwapStep(window: window, forward: !forward) }
}

/// Walks `a` over to `b`'s slot, which shifts the windows in between by one,
/// then walks `b` back to where `a` was, which shifts them back.
func swapSteps(_ order: [CGWindowID], _ a: CGWindowID, _ b: CGWindowID) -> [SwapStep] {
    guard let i = order.firstIndex(of: a), let j = order.firstIndex(of: b), i != j else { return [] }
    let distance = abs(j - i)
    return Array(repeating: SwapStep(window: a, forward: j > i), count: distance)
        + Array(repeating: SwapStep(window: b, forward: j < i), count: distance - 1)
}

func evalExpression(_ steps: [SwapStep]) -> String { steps.map(\.command).joined(separator: "; ") }

/// One eval, so AeroSpace lays the workspace out once rather than per step.
func swap(_ a: Window, _ b: Window, order: [CGWindowID]) {
    let steps = swapSteps(order, a.id, b.id)
    aerospace("eval", evalExpression(steps))
    // A misread layout lands the pair somewhere else, so check, and undo if so.
    if !settled([(a.id, b.frame), (b.id, a.frame)]) {
        aerospace("eval", evalExpression(steps.reversed().map(\.inverse)))
        NSSound.beep()
    }
}

/// Whether each window's center moves into its slot within half a second.
func settled(_ slots: [(CGWindowID, CGRect)]) -> Bool {
    let deadline = Date().addingTimeInterval(0.5)
    repeat {
        let frames = onscreenFrames()
        let landed = slots.allSatisfy { id, slot in
            frames[id].map { slot.contains(CGPoint(x: $0.midX, y: $0.midY)) } ?? false
        }
        if landed { return true }
        usleep(20_000)
    } while Date() < deadline
    return false
}

// MARK: - Badges

enum Badge {
    static let size = NSSize(width: 84, height: 84)
    static let circle = NSRect(x: 8, y: 18, width: 60, height: 60)
    static let icon = NSRect(x: 50, y: 8, width: 28, height: 28)
}

func roundedFont(_ size: CGFloat, _ weight: NSFont.Weight) -> NSFont {
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    return font.fontDescriptor.withDesign(.rounded).flatMap { NSFont(descriptor: $0, size: size) } ?? font
}

/// Draws `text` with its capitals, rather than its line box, centered on `point`.
func drawCentered(_ text: String, _ font: NSFont, _ color: NSColor, at point: NSPoint) {
    let label = NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    label.draw(at: NSPoint(x: point.x - label.size().width / 2, y: point.y - font.capHeight / 2 + font.descender))
}

final class BadgeView: NSView {
    enum Kind { case target, focused, source }
    let text: String
    let kind: Kind
    let icon: NSImage?

    init(text: String, kind: Kind, icon: NSImage?) {
        (self.text, self.kind, self.icon) = (text, kind, icon)
        super.init(frame: NSRect(origin: .zero, size: Badge.size))
    }

    required init?(coder: NSCoder) { return nil }

    override func draw(_ dirtyRect: NSRect) {
        let circle = NSBezierPath(ovalIn: Badge.circle)
        (kind == .source ? NSColor.controlAccentColor : NSColor(white: 0.08, alpha: 0.85)).setFill()
        circle.fill()
        if kind != .source {
            circle.lineWidth = kind == .focused ? 4 : 2
            (kind == .focused ? NSColor.controlAccentColor : NSColor(white: 1, alpha: 0.85)).setStroke()
            circle.stroke()
        }
        drawCentered(text, roundedFont(30, .bold), .white, at: NSPoint(x: Badge.circle.midX, y: Badge.circle.midY))
        icon?.draw(in: Badge.icon)
    }
}

/// A stop on the workspace ring: its key, and the workspace when that says more.
final class WorkspaceView: NSView {
    static let size = NSSize(width: 46, height: 46)
    let key: String
    let workspace: String?

    init(key: Character, workspace: String) {
        let key = key.uppercased()
        (self.key, self.workspace) = (key, workspace == key ? nil : workspace)
        super.init(frame: NSRect(origin: .zero, size: Self.size))
    }

    required init?(coder: NSCoder) { return nil }

    override func draw(_ dirtyRect: NSRect) {
        let circle = NSBezierPath(ovalIn: bounds.insetBy(dx: 1, dy: 1))
        NSColor(white: 0.08, alpha: 0.85).setFill()
        circle.fill()
        circle.lineWidth = 1.5
        NSColor(white: 1, alpha: 0.85).setStroke()
        circle.stroke()
        let keyCenter = NSPoint(x: bounds.midX, y: bounds.midY + (workspace == nil ? 0 : 4))
        drawCentered(key, roundedFont(20, .bold), .white, at: keyCenter)
        if let workspace {
            drawCentered(workspace, roundedFont(9, .semibold), NSColor(white: 1, alpha: 0.7),
                         at: NSPoint(x: bounds.midX, y: bounds.midY - 11))
        }
    }
}

var badges: [CGWindowID: NSPanel] = [:]

func makePanel(_ view: NSView, frame: NSRect) -> NSPanel {
    let panel = NSPanel(contentRect: frame, styleMask: [.borderless, .nonactivatingPanel],
                        backing: .buffered, defer: false)
    panel.isOpaque = false
    panel.backgroundColor = .clear
    panel.hasShadow = true
    panel.level = .screenSaver
    panel.ignoresMouseEvents = true
    panel.hidesOnDeactivate = false
    panel.animationBehavior = .none
    panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
    panel.contentView = view
    panel.orderFrontRegardless()
    return panel
}

func appIcon(_ window: Window) -> NSImage? { NSRunningApplication(processIdentifier: window.pid)?.icon }

/// Puts a badge's circle over the middle of the window, below any badge already there.
func showBadge(for window: Window, text: String, kind: BadgeView.Kind) {
    let mainHeight = NSScreen.screens.first?.frame.height ?? 0
    var rect = NSRect(origin: NSPoint(x: window.frame.midX - Badge.circle.midX,
                                      y: mainHeight - window.frame.midY - Badge.circle.midY),
                      size: Badge.size)
    while badges.values.contains(where: { $0.frame.intersects(rect) }) { rect.origin.y -= Badge.size.height }
    badges[window.id] = makePanel(BadgeView(text: text, kind: kind, icon: appIcon(window)), frame: rect)
}

func restyleBadge(for window: Window, text: String, kind: BadgeView.Kind) {
    badges[window.id]?.contentView = BadgeView(text: text, kind: kind, icon: appIcon(window))
}

func hideBadges(except kept: Set<CGWindowID>) {
    for (id, badge) in badges where !kept.contains(id) { badge.orderOut(nil) }
}

func hideEverything() { NSApp.windows.forEach { $0.orderOut(nil) } }

/// Fans the workspaces out clockwise from the top around the window's badge,
/// moving the badge back from the screen edge first if the ring needs room.
func showRing(_ workspaces: [Character: String], around window: Window) {
    guard let badge = badges[window.id] else { return }
    let keys = workspaces.keys.sorted()
    let radius = max(100, CGFloat(keys.count) * (WorkspaceView.size.width + 12) / (2 * .pi))
    var center = NSPoint(x: badge.frame.minX + Badge.circle.midX, y: badge.frame.minY + Badge.circle.midY)
    if let screen = NSScreen.screens.first(where: { $0.frame.contains(center) }) {
        let room = screen.visibleFrame.insetBy(dx: radius + WorkspaceView.size.width,
                                               dy: radius + WorkspaceView.size.height)
        center = NSPoint(x: min(max(center.x, room.minX), room.maxX), y: min(max(center.y, room.minY), room.maxY))
        badge.setFrameOrigin(NSPoint(x: center.x - Badge.circle.midX, y: center.y - Badge.circle.midY))
    }
    func frame(around point: NSPoint) -> NSRect {
        NSRect(origin: NSPoint(x: point.x - WorkspaceView.size.width / 2, y: point.y - WorkspaceView.size.height / 2),
               size: WorkspaceView.size)
    }
    for (i, key) in keys.enumerated() {
        let angle = CGFloat.pi / 2 - CGFloat(i) * 2 * .pi / CGFloat(keys.count)
        let stop = NSPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        let panel = makePanel(WorkspaceView(key: key, workspace: workspaces[key]!), frame: frame(around: center))
        panel.alphaValue = 0
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().setFrame(frame(around: stop), display: true)
            panel.animator().alphaValue = 1
        }
    }
}

// MARK: - Keys

let keyCodes: [Character: Int] = [
    "a": kVK_ANSI_A, "b": kVK_ANSI_B, "c": kVK_ANSI_C, "d": kVK_ANSI_D, "e": kVK_ANSI_E, "f": kVK_ANSI_F,
    "g": kVK_ANSI_G, "h": kVK_ANSI_H, "i": kVK_ANSI_I, "j": kVK_ANSI_J, "k": kVK_ANSI_K, "l": kVK_ANSI_L,
    "m": kVK_ANSI_M, "n": kVK_ANSI_N, "o": kVK_ANSI_O, "p": kVK_ANSI_P, "q": kVK_ANSI_Q, "r": kVK_ANSI_R,
    "s": kVK_ANSI_S, "t": kVK_ANSI_T, "u": kVK_ANSI_U, "v": kVK_ANSI_V, "w": kVK_ANSI_W, "x": kVK_ANSI_X,
    "y": kVK_ANSI_Y, "z": kVK_ANSI_Z,
]

struct HotKey {
    let ref: EventHotKeyRef?
    let keyCode: Int
    let modifiers: Int
    let press: () -> Void
    let release: () -> Void
}

var hotKeys: [UInt32: HotKey] = [:]
var nextHotKeyId: UInt32 = 1

func onKey(_ keyCode: Int, modifiers: Int = 0, press: @escaping () -> Void, release: @escaping () -> Void = {}) {
    var ref: EventHotKeyRef?
    let id = EventHotKeyID(signature: 0x5748_4E54, id: nextHotKeyId) // 'WHNT'
    guard RegisterEventHotKey(UInt32(keyCode), UInt32(modifiers), id, GetApplicationEventTarget(), 0, &ref)
        == noErr else { return }
    hotKeys[nextHotKeyId] = HotKey(ref: ref, keyCode: keyCode, modifiers: modifiers, press: press, release: release)
    nextHotKeyId += 1
}

/// Hands every key back to the other apps except the unshifted `keyCode`.
func releaseKeys(except keyCode: Int) {
    for (id, hotKey) in hotKeys where hotKey.keyCode != keyCode || hotKey.modifiers != 0 {
        UnregisterEventHotKey(hotKey.ref)
        hotKeys[id] = nil
    }
}

func listenForHotKeys() {
    var kinds = [kEventHotKeyPressed, kEventHotKeyReleased].map {
        EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32($0))
    }
    InstallEventHandler(GetApplicationEventTarget(), { _, event, _ in
        var id = EventHotKeyID()
        GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID),
                          nil, MemoryLayout<EventHotKeyID>.size, nil, &id)
        guard let hotKey = hotKeys[id.id] else { return noErr }
        if GetEventKind(event) == UInt32(kEventHotKeyPressed) { hotKey.press() } else { hotKey.release() }
        return noErr
    }, kinds.count, &kinds, nil, nil)
}

/// Keeps one set of letters up at a time: running the same mode again takes
/// them down, and running the other mode replaces them.
func takeOver(_ mode: Mode) {
    let path = NSTemporaryDirectory() + "window-hints.lock"
    let fd = open(path, O_RDWR | O_CREAT, 0o600)
    guard fd >= 0 else { return }
    if flock(fd, LOCK_EX | LOCK_NB) != 0 {
        let holder = (try? String(contentsOfFile: path, encoding: .utf8))?.split(separator: " ") ?? []
        if let pid = holder.first.flatMap({ pid_t($0) }) { kill(pid, SIGTERM) }
        if holder.last == Substring(mode.rawValue) { exit(0) }
        flock(fd, LOCK_EX)
    }
    ftruncate(fd, 0)
    let record = "\(getpid()) \(mode.rawValue)"
    _ = record.withCString { pwrite(fd, $0, strlen($0), 0) }
    // The descriptor stays open, and the lock held, until the process exits.
}

// MARK: - Main

let arguments = CommandLine.arguments.dropFirst()
guard let mode = arguments.first.flatMap(Mode.init(rawValue:)) else {
    FileHandle.standardError.write(Data("usage: window-hints focus|swap [--dry-run]\n".utf8))
    exit(2)
}
let dryRun = arguments.contains("--dry-run")
if !dryRun { takeOver(mode) }

let readWorkspaceKeys = mode == .focus ? startReadingWorkspaceKeys() : { [:] }
let windows = visibleWindows()
let workspaceKeys = readWorkspaceKeys()
// Letters follow the same windows in both modes.
let picks = zip(letters, windows).map { Pick(letter: $0, window: $1) }
let focused = windows.first(where: \.focused)

if dryRun {
    func describe(_ w: Window) -> String { "\(w.app) [\(w.id)] on \(w.workspace)\(w.focused ? " (focused)" : "")" }
    switch mode {
    case .focus:
        for pick in picks { print("\(pick.letter)  \(describe(pick.window))") }
        print("ring: " + workspaceKeys.sorted { $0.key < $1.key }.map { "\($0.key) \($0.value)" }.joined(separator: ", "))
    case .swap:
        if let focused, let plan = swapPlan(for: focused, windows: windows, picks: picks) {
            for pick in plan.targets {
                let steps = swapSteps(plan.order, focused.id, pick.window.id)
                print("\(pick.letter)  \(describe(pick.window)): \(evalExpression(steps))")
            }
        }
    }
    exit(0)
}

// In focus mode a letter going down could be a tap or a hold, which only its
// release or the hold delay can tell apart; a tap then waits briefly in case a
// second one follows.
enum Stage {
    case choosing
    case pressing(Pick, poll: Timer)
    case tapped(Pick)
    case carrying(Pick, SwapPlan)
    case sending(Pick, workspaces: [Character: String])
}
var stage = Stage.choosing

func isDown(_ letter: Character) -> Bool {
    CGEventSource.keyState(.combinedSessionState, key: CGKeyCode(keyCodes[letter]!))
}

func focusModePress(_ letter: Character, shift: Bool) {
    switch stage {
    case .choosing:
        guard let pick = picks.first(where: { $0.letter == letter }) else { exit(0) }
        if shift { return openRing(for: pick) }
        // Watch the key itself as well as the hotkey's release event, so a
        // release that goes astray cannot turn a tap into a hold.
        let pressed = Date()
        stage = .pressing(pick, poll: Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { poll in
            if !isDown(letter) {
                poll.invalidate()
                tap(pick)
            } else if Date().timeIntervalSince(pressed) >= holdDelay {
                poll.invalidate()
                pickUp(pick)
            }
        })
    case .pressing:
        break // another letter while one is down
    case .tapped(let pick):
        if letter == pick.letter { aerospace("fullscreen", "--window-id", String(pick.window.id)) }
        exit(0)
    case .carrying(let pick, let plan):
        if letter == pick.letter { return } // the one being carried
        if let target = plan.targets.first(where: { $0.letter == letter }) {
            hideEverything()
            swap(pick.window, target.window, order: plan.order)
        }
        exit(0)
    case .sending(let pick, let workspaces):
        if letter == pick.letter && isDown(letter) { return } // still down from opening the ring
        if let workspace = workspaces[letter] {
            hideEverything()
            // As with alt-<key> and alt-shift-<key>: go there with it, or send it on its own.
            let follow = shift ? [] : ["--focus-follows-window"]
            _ = startAerospace(["move-node-to-workspace", "--window-id", String(pick.window.id)] + follow + [workspace])()
        }
        exit(0)
    }
}

func focusModeRelease(_ letter: Character) {
    guard case .pressing(let pick, let poll) = stage, pick.letter == letter else { return }
    poll.invalidate()
    tap(pick)
}

func tap(_ pick: Pick) {
    hideEverything()
    aerospace("focus", "--window-id", String(pick.window.id))
    // Only a second tap of the same letter still means anything.
    stage = .tapped(pick)
    releaseKeys(except: keyCodes[pick.letter]!)
    DispatchQueue.main.asyncAfter(deadline: .now() + doubleTapWindow) { exit(0) }
}

func pickUp(_ pick: Pick) {
    guard let plan = swapPlan(for: pick.window, windows: windows, picks: picks) else {
        NSSound.beep()
        stage = .choosing
        return
    }
    hideBadges(except: Set(plan.targets.map(\.window.id) + [pick.window.id]))
    restyleBadge(for: pick.window, text: "⇄", kind: .source)
    stage = .carrying(pick, plan)
}

func openRing(for pick: Pick) {
    let workspaces = workspaceKeys.filter { $0.value != pick.window.workspace }
    guard !workspaces.isEmpty else { return NSSound.beep() }
    hideBadges(except: [pick.window.id])
    restyleBadge(for: pick.window, text: pick.letter.uppercased(), kind: .source)
    showRing(workspaces, around: pick.window)
    stage = .sending(pick, workspaces: workspaces)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

var pressLetter: (Character, _ shift: Bool) -> Void = focusModePress
var releaseLetter: (Character) -> Void = focusModeRelease

switch mode {
case .focus:
    guard !picks.isEmpty else {
        NSSound.beep()
        exit(1)
    }
    for pick in picks {
        showBadge(for: pick.window, text: pick.letter.uppercased(), kind: pick.window.focused ? .focused : .target)
    }
case .swap:
    guard let focused, let plan = swapPlan(for: focused, windows: windows, picks: picks) else {
        NSSound.beep()
        exit(1)
    }
    showBadge(for: focused, text: "⇄", kind: .source)
    for pick in plan.targets { showBadge(for: pick.window, text: pick.letter.uppercased(), kind: .target) }
    // Shift may still be down from alt-shift-w, so here it changes nothing.
    pressLetter = { letter, _ in
        if let target = plan.targets.first(where: { $0.letter == letter }) {
            hideEverything()
            swap(focused, target.window, order: plan.order)
        }
        exit(0)
    }
    releaseLetter = { _ in }
}

// Every letter is taken while the badges are up, so a miss cannot type into
// the focused app; it just dismisses them.
for (letter, keyCode) in keyCodes {
    for modifiers in [0, shiftKey] {
        onKey(keyCode, modifiers: modifiers, press: { pressLetter(letter, modifiers == shiftKey) },
              release: { releaseLetter(letter) })
    }
}
onKey(kVK_Escape, press: { exit(0) })
listenForHotKeys()

NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: .main
) { _ in
    // A tap switches apps itself, and a second tap may still follow.
    if case .tapped = stage { return }
    exit(0)
}
NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { _ in exit(0) }
DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) { exit(0) }
app.run()
