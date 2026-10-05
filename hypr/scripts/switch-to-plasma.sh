#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  switch-to-plasma.sh — leave Hyprland and go to KDE Plasma
#
#  How session switching actually works on this machine:
#
#  Plasma is served by plasmalogin (systemd service `plasmalogin.service`,
#  socket-activated on tty2). Hyprland is *not* registered with that
#  display manager, so a Hyprland session is a plain session sitting on top
#  of whatever started it.
#
#  The robust way to move between them is to get back to the login screen and
#  pick the session there. This script does that directly: it tells
#  plasmalogin to restart, which drops you to the login screen, where you can
#  then choose "Plasma (Wayland)" or "Hyprland".
#
#  If Hyprland was started from inside Plasma's session (loginctl), this
#  script instead terminates just the Hyprland session and returns you to
#  Plasma. Both paths are handled.
# ═══════════════════════════════════════════════════════════════════════════
set -u

LOG="$HOME/.cache/switch-to-plasma.log"
log() { printf '%s %s\n' "$(date +%T)" "$*" >>"$LOG"; }

log "==== switch-to-plasma invoked ===="

confirm() {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a "Session" "Suzumi Night" "$1" 2>/dev/null
    log "$1"
}

# ── 1. Are we a nested Hyprland inside a Plasma session? ──────────────────
# If the outer session is Plasma, killing Hyprland is all that's needed.
OUTER="${XDG_SESSION_DESKTOP:-}"
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && [ "${OUTER:-}" != "hyprland" ] \
   && [ "${OUTER:-}" != "Hyprland" ]; then
    log "nested inside '$OUTER' — just closing the Hyprland session"
    confirm "Returning to $OUTER…"
    hyprctl dispatch exit 2>/dev/null || pkill -x Hyprland
    sleep 1
    exit 0
fi

# ── 2. Standalone Hyprland: hand the seat back to plasmalogin ─────────────
confirm "Switching to KDE Plasma…"
log "restarting plasmalogin.service (returns to the login screen)"

# Make sure nothing grabs input on the way out.
makoctl dismiss 2>/dev/null || true
pkill -x hypridle  2>/dev/null || true
pkill -x hyprlock  2>/dev/null || true
pkill -x mpvpaper  2>/dev/null || true
pkill -x waybar    2>/dev/null || true
pkill -x swww-daemon 2>/dev/null || true

sleep 0.5

# Restarting plasmalogin is the supported way to return to the login screen
# on Garuda; it re-activates its own systemd socket.
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user restart plasmalogin.service 2>/dev/null \
        || systemctl restart plasmalogin.service 2>/dev/null \
        || true
fi

# Fallback: kill Hyprland and let the seat's idle action bring the greeter up.
hyprctl dispatch exit 2>/dev/null || pkill -x Hyprland

log "handed over — choose 'Plasma (Wayland)' at the login screen"
exit 0
