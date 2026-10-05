#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  layout-toggle.sh — flip the active workspace between dwindle and master
#
#  Hyprland 0.56 has no `togglesplit` dispatcher any more, so we flip the
#  config keyword instead. That is a global switch, which is exactly what the
#  old toggle used to do.
# ═══════════════════════════════════════════════════════════════════════════
set -u

CURRENT=$(hyprctl getoption general:layout 2>/dev/null | sed -n 's/.*: //p' | tr -d '"')

case "$CURRENT" in
    master)
        hyprctl keyword general:layout dwindle
        notify-send -a "Hyprland" "Layout" "dindle" 2>/dev/null
        ;;
    dwindle|*)
        hyprctl keyword general:layout master
        notify-send -a "Hyprland" "Layout" "master" 2>/dev/null
        ;;
esac
