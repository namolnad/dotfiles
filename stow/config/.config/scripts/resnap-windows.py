#!/usr/bin/env python3
"""Apply aerospace.toml's on-window-detected rules to windows that are ALREADY open.

AeroSpace only evaluates on-window-detected at window creation, so windows that
existed before a rule was added (or before a config reload) stay where they are.
This re-runs the same rules over the current window list.

Rules are read straight from aerospace.toml, so there is one source of truth.

Usage:
  resnap-windows.py            # move windows
  resnap-windows.py --dry-run  # just show what would move
"""

import json
import os
import re
import shutil
import subprocess
import sys

CONFIG = os.path.expanduser("~/.config/aerospace/aerospace.toml")

# Launched from AeroSpace's exec-and-forget, PATH is bash's default and will
# not include Homebrew, so resolve the binary explicitly.
AEROSPACE = shutil.which("aerospace") or next(
    (c for c in ("/opt/homebrew/bin/aerospace", "/usr/local/bin/aerospace")
     if os.path.exists(c)),
    "aerospace",
)

# 'value' or "value" -> value
_STR = r"""\s*=\s*['"](.*)['"]\s*$"""
PATTERNS = {
    "app-id": re.compile(r"^if\.app-id" + _STR),
    "app-name": re.compile(r"^if\.app-name-regex-substring" + _STR),
    "title": re.compile(r"^if\.window-title-regex-substring" + _STR),
}
RUN_RE = re.compile(r"""^run\s*=\s*['"]move-node-to-workspace\s+(\S+?)['"]\s*$""")


def parse_rules(path):
    """Return [{app-id, app-name, title, workspace}] in config order."""
    rules, cur = [], None
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("[[on-window-detected]]"):
                if cur and cur.get("workspace"):
                    rules.append(cur)
                cur = {}
                continue
            if cur is None or not line or line.startswith("#"):
                continue
            if line.startswith("["):  # left the on-window-detected blocks
                if cur.get("workspace"):
                    rules.append(cur)
                cur = None
                continue
            for key, pat in PATTERNS.items():
                m = pat.match(line)
                if m:
                    cur[key] = m.group(1)
                    break
            else:
                m = RUN_RE.match(line)
                if m:
                    cur["workspace"] = m.group(1)
    if cur and cur.get("workspace"):
        rules.append(cur)
    return rules


def matches(rule, win):
    """Every 'if.' condition present on the rule must match (AeroSpace semantics)."""
    if "app-id" in rule and rule["app-id"] != (win.get("app-bundle-id") or ""):
        return False
    if "app-name" in rule and not re.search(rule["app-name"], win.get("app-name") or ""):
        return False
    if "title" in rule and not re.search(rule["title"], win.get("window-title") or ""):
        return False
    return "app-id" in rule or "app-name" in rule or "title" in rule


def main():
    dry_run = "--dry-run" in sys.argv or "-n" in sys.argv

    rules = parse_rules(CONFIG)
    if not rules:
        sys.exit(f"No on-window-detected rules found in {CONFIG}")

    windows = json.loads(
        subprocess.run(
            [AEROSPACE, "list-windows", "--all", "--json", "--format",
             "%{window-id}%{app-bundle-id}%{app-name}%{window-title}%{workspace}"],
            capture_output=True, text=True, check=True,
        ).stdout
    )

    moved = skipped = 0
    for win in windows:
        rule = next((r for r in rules if matches(r, win)), None)
        if rule is None:
            continue
        target = rule["workspace"]
        if win.get("workspace") == target:
            skipped += 1
            continue

        label = f"{win['app-name']}: {win['window-title']}"
        print(f"  {win.get('workspace'):>4} -> {target:<4}  {label[:70]}")
        if not dry_run:
            subprocess.run(
                [AEROSPACE, "move-node-to-workspace",
                 "--window-id", str(win["window-id"]), "--", target],
                check=False,
            )
        moved += 1

    verb = "would move" if dry_run else "moved"
    print(f"\n{verb} {moved}, already correct {skipped}, "
          f"{len(windows) - moved - skipped} unmatched")


if __name__ == "__main__":
    main()
