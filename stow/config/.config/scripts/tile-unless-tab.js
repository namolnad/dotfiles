#!/usr/bin/osascript -l JavaScript
// Tile a newly detected window unless it is a native macOS tab.
//
// macOS reports each native tab as a window of its own (AeroSpace #68), so
// AeroSpace tiles a new tab beside the window it belongs to: the window shrinks
// and an empty slot opens next to it. aerospace.toml floats new windows of
// tab-capable apps as they appear and hands them to this script, which tiles
// the real windows and leaves the tabs floating. A tab opens exactly on top of
// a tiled window of the same app; a real window does not.
//
// Usage: tile-unless-tab.js <window-id> [--dry-run]

ObjC.import('CoreGraphics');

const AEROSPACE = ['/opt/homebrew/bin/aerospace', '/usr/local/bin/aerospace']
  .find(p => $.NSFileManager.defaultManager.isExecutableFileAtPath(p));

const app = Application.currentApplication();
app.includeStandardAdditions = true;

function aerospace(...args) {
  const quoted = [AEROSPACE, ...args].map(a => `'${String(a).replace(/'/g, `'\\''`)}'`);
  return app.doShellScript(quoted.join(' '), { alteringLineEndings: false });
}

// AeroSpace window ids are CGWindowIDs, so CoreGraphics can answer what the
// Accessibility API cannot: whether a window is actually on screen.
function cgWindows() {
  const raw = $.CGWindowListCopyWindowInfo($.kCGWindowListOptionAll, $.kCGNullWindowID);
  return new Map(ObjC.deepUnwrap(ObjC.castRefToObject(raw)).map(w => [w.kCGWindowNumber, w]));
}

const sameFrame = (a, b) => ['X', 'Y', 'Width', 'Height'].every(k => Math.abs(a[k] - b[k]) <= 2);

function run(argv) {
  const id = Number(argv[0]);
  const dryRun = argv.includes('--dry-run');
  if (!id || !AEROSPACE) return 'usage: tile-unless-tab.js <window-id> [--dry-run]';

  // Background tabs are ordered out, but so is a new tab for its first half
  // second or so while Finder loads it. Waiting costs nothing, since the
  // window is already floating, so only give up after a few seconds.
  let cg;
  const deadline = Date.now() + 3000;
  for (;;) {
    cg = cgWindows();
    if (cg.get(id)?.kCGWindowIsOnscreen || Date.now() > deadline) break;
    delay(0.05);
  }
  const self = cg.get(id);
  if (!self) return `${id}: gone`;
  if (!self.kCGWindowIsOnscreen) return `${id}: background tab, left floating`;

  const windows = JSON.parse(aerospace('list-windows', '--monitor', 'all', '--json', '--format',
    '%{window-id}%{app-bundle-id}%{window-layout}%{workspace}%{workspace-is-visible}'));
  const win = windows.find(w => w['window-id'] === id);
  if (!win || win['window-layout'] !== 'floating') return `${id}: not floating, left alone`;

  // Windows on hidden workspaces are parked in a screen corner, so frames only
  // mean something on a visible workspace, which is where tabs get opened.
  const host = win['workspace-is-visible'] && windows.find(w =>
    w['window-id'] !== id &&
    w['app-bundle-id'] === win['app-bundle-id'] &&
    w.workspace === win.workspace &&
    w['window-layout'] !== 'floating' &&
    cg.has(w['window-id']) &&
    sameFrame(cg.get(w['window-id']).kCGWindowBounds, self.kCGWindowBounds));
  if (host) return `${id}: tab of ${host['window-id']}, left floating`;

  if (!dryRun) aerospace('layout', 'tiling', '--window-id', String(id));
  return `${id}: window, ${dryRun ? 'would tile' : 'tiled'}`;
}
