#!/usr/bin/env python3
"""Generate ~/.claude/settings.json from the tracked common + per-OS layers.

Claude Code has no user-scope override layer: ``~/.claude/settings.local.json``
is NOT read (``settings.local.json`` is project-scoped only, and the precedence
chain is user -> project -> local). So the two machines cannot share one
symlinked settings.json and still differ. Instead the repo tracks the pieces and
this script composes them into a real file.

    claude/settings.common.json   shared by every machine
    claude/settings.linux.json    Linux-only overlay
    claude/settings.macos.json    macOS-only overlay

Merge rules:
  * permissions.{allow,deny,ask,additionalDirectories}  union, common first,
                                                        duplicates dropped
  * objects (modelSettings, skillOverrides, hooks, enabledPlugins, ...)
                                                        recursive merge
  * scalars                                             the OS overlay wins

Usage:
    python3 claude/build-settings.py                 # write ~/.claude/settings.json
    python3 claude/build-settings.py --dry-run       # show the diff, write nothing
    python3 claude/build-settings.py --os macos      # compose for the other machine
    python3 claude/build-settings.py -o /tmp/s.json  # write somewhere else
"""

from __future__ import annotations

import argparse
import difflib
import json
import platform
import shutil
import sys
from collections import OrderedDict
from datetime import datetime
from pathlib import Path

HERE = Path(__file__).resolve().parent
UNION_KEYS = ("allow", "deny", "ask", "additionalDirectories")


def load(path: Path) -> OrderedDict:
    with path.open(encoding="utf-8") as fh:
        return json.load(fh, object_pairs_hook=OrderedDict)


def merge(base, overlay, *, union_lists=False):
    """Recursively merge overlay onto base. Lists union only where asked."""
    if isinstance(base, dict) and isinstance(overlay, dict):
        out = OrderedDict(base)
        for key, value in overlay.items():
            if key in out:
                out[key] = merge(out[key], value, union_lists=key in UNION_KEYS)
            else:
                out[key] = value
        return out
    if union_lists and isinstance(base, list) and isinstance(overlay, list):
        seen, out = set(), []
        for item in [*base, *overlay]:
            marker = json.dumps(item, sort_keys=True)
            if marker in seen:
                continue
            seen.add(marker)
            out.append(item)
        return out
    return overlay


def detect_os() -> str:
    system = platform.system()
    if system == "Darwin":
        return "macos"
    if system == "Linux":
        return "linux"
    sys.exit(f"unsupported platform: {system} (pass --os linux|macos)")


def render(obj) -> str:
    return json.dumps(obj, indent=2, ensure_ascii=False) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--os", choices=("linux", "macos", "auto"), default="auto",
                        help="overlay to apply (default: detect this machine)")
    parser.add_argument("-o", "--output", type=Path,
                        default=Path.home() / ".claude" / "settings.json",
                        help="destination (default: ~/.claude/settings.json)")
    parser.add_argument("-n", "--dry-run", action="store_true",
                        help="print the diff against the destination and exit")
    parser.add_argument("--no-backup", action="store_true",
                        help="overwrite without keeping a timestamped backup")
    args = parser.parse_args()

    target_os = detect_os() if args.os == "auto" else args.os

    common_path = HERE / "settings.common.json"
    overlay_path = HERE / f"settings.{target_os}.json"
    for path in (common_path, overlay_path):
        if not path.is_file():
            sys.exit(f"missing layer: {path}")

    merged = merge(load(common_path), load(overlay_path))
    new_text = render(merged)

    old_text = ""
    if args.output.is_file():
        old_text = args.output.read_text(encoding="utf-8")

    if old_text == new_text:
        print(f"{args.output} already up to date ({target_os})")
        return 0

    diff = "".join(difflib.unified_diff(
        old_text.splitlines(keepends=True), new_text.splitlines(keepends=True),
        fromfile=f"{args.output} (current)", tofile=f"composed ({target_os})"))

    if args.dry_run:
        print(diff or "(destination does not exist yet)")
        return 0

    if old_text and not args.no_backup:
        stamp = datetime.now().strftime("%Y%m%d%H%M%S")
        backup = args.output.with_suffix(f".json.bak.{stamp}")
        shutil.copy2(args.output, backup)
        print(f"backed up -> {backup}")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(new_text, encoding="utf-8")
    print(f"wrote {args.output} ({target_os})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
