#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  animation-toggle.sh — turn all animations on or off   (SUPER+ALT+M)
#
#  `hyprctl keyword` does not work with Hyprland 0.56's Lua config
#  ("keyword can't work with non-legacy parsers. Use eval."), so this uses
#  `hyprctl eval 'hl.config({...})'`.
# ═══════════════════════════════════════════════════════════════════════════
set -u

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-animations-state"
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo true)

case "$CURRENT" in
    false) WANT=true;  MSG="animations on" ;;
    *)     WANT=false; MSG="animations off" ;;
esac

hyprctl eval "hl.config({ animations = { enabled = $WANT } })" >/dev/null 2>&1
printf '%s' "$WANT" > "$STATE_FILE"
command -v notify-send >/dev/null 2>&1 && notify-send -a "Hyprland" "$MSG" 2>/dev/null
echo "$MSG"
