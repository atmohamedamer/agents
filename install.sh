#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./install.sh [--src <path-to-repo-root>] [--dst <path-to-workspace-root>]
# Defaults: --src = script dir; --dst = CWD

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DST="$(pwd)"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --src) SRC="$(cd "$2" && pwd)"; shift 2;;
    --dst) DST="$(mkdir -p "$2"; cd "$2" && pwd)"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

AGENTS_SRC="$SRC/.agents"
CLAUDE_SRC="$SRC/agents"
[[ -d "$AGENTS_SRC" ]] || { echo "Missing: $AGENTS_SRC" >&2; exit 1; }
[[ -d "$CLAUDE_SRC" ]] || { echo "Missing: $CLAUDE_SRC" >&2; exit 1; }

# .agents -> workspace/.agents  (skip if exists)
AGENTS_DST="$DST/.agents"
if [[ -e "$AGENTS_DST" ]]; then
  echo "Skip: $AGENTS_DST already exists."
else
  echo "Copy: $AGENTS_SRC -> $AGENTS_DST"
  cp -a "$AGENTS_SRC" "$AGENTS_DST"
fi

# agents -> workspace/.claude/agents  (skip if exists)
CLAUDE_DST="$DST/.claude/agents"
if [[ -e "$CLAUDE_DST" ]]; then
  echo "Skip: $CLAUDE_DST already exists."
else
  echo "Copy: $CLAUDE_SRC -> $CLAUDE_DST"
  mkdir -p "$(dirname "$CLAUDE_DST")"
  cp -a "$CLAUDE_SRC" "$CLAUDE_DST"
fi

echo "Done."
