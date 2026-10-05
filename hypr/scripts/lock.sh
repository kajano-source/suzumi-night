#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  lock.sh — lock the screen, the friendly way
#  Blanks the notifications first, then hands over to hyprlock.
# ═══════════════════════════════════════════════════════════════════════════
set -u

makoctl dismiss 2>/dev/null || true

# If something has the keyboard grabbed (a stuck fullscreen game, say) hyprlock
# can fail to take focus. Nudge it in front.
if command -v wmctrl >/dev/null 2>&1; then
    wmctrl -a hyprlock 2>/dev/null || true
fi

exec hyprlock
