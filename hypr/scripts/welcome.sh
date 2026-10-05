#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  welcome.sh — the little "session is alive" notification + first-run tips
# ═══════════════════════════════════════════════════════════════════════════
set -u

# Don't nag on every single reload — once per calendar day is plenty.
STAMP_FILE="$HOME/.cache/hypr-welcome-stamp"
TODAY=$(date +%F)
[ -f "$STAMP_FILE" ] && [ "$(cat "$STAMP_FILE")" = "$TODAY" ] && exit 0
printf '%s' "$TODAY" > "$STAMP_FILE"

# Give mako a moment to be listening.
sleep 2

command -v notify-send >/dev/null 2>&1 || exit 0

notify-send \
    -a "Suzumi Night" \
    -i "$HOME/.local/share/hypr-rice/avatar.png" \
    -h string:x-canonical-private-synchronous:hypr-welcome \
    "Hyprland is live ✨" \
    "SUPER+D menu · SUPER+E files · SUPER+Return terminal
SUPER+W wallpaper · SUPER+SHIFT+ESC → KDE Plasma
SUPER+L lock · SUPER+P power"

exit 0
