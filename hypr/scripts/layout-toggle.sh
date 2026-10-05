#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  layout-toggle.sh — flip between the dwindle and master layouts
#
#  ⚠ Hyprland 0.56 runs a Lua config, and `hyprctl keyword` refuses to work
#    with it:  "keyword can't work with non-legacy parsers. Use eval."
#    So this goes through `hyprctl eval 'hl.config({...})'` instead.
#
#  There is no way to read the live layout back out of the config through the
#    eval API (hl.get_config() does not expose `general.layout`), so the
#    current state is tracked in a file instead.
# ═══════════════════════════════════════════════════════════════════════════
set -u

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-layout-state"
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo dwindle)

set_layout() {
    hyprctl eval "hl.config({ general = { layout = \"$1\" } })" >/dev/null 2>&1
    printf '%s' "$1" > "$STATE_FILE"
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a "Hyprland" "Layout" "$1" 2>/dev/null
    echo "layout: $1"
}

case "$CURRENT" in
    master) set_layout dwindle ;;
    *)      set_layout master ;;
esac
