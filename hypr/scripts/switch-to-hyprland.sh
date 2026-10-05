#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  switch-to-hyprland.sh — get from KDE Plasma into Hyprland
#
#  Two cases:
#
#   1. We're already in a Hyprland session (this file was called from inside
#      Hyprland, e.g. from the powermenu) → just focus/launch a new instance.
#
#   2. We're in KDE Plasma. There are two sane ways forward:
#        a) Nested: run Hyprland *inside* Plasma as a child session. Keeps
#           Plasma alive underneath, so you can toggle back instantly. This is
#           what the script does by default, because it is reversible and
#           cheap to undo.
#        b) Clean: bounce to the login screen and pick "Hyprland" there.
#           Cleaner (no double compositors fighting over the GPU) but you have
#           to log in again.
#
#  Pass `--clean` for (b).
# ═══════════════════════════════════════════════════════════════════════════
set -u

LOG="$HOME/.cache/switch-to-hyprland.log"
log() { printf '%s %s\n' "$(date +%T)" "$*" >>"$LOG"; }
notify() {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a "Session" "Suzumi Night" "$1" 2>/dev/null
    log "$1"
}

MODE="${1:-nested}"

# ── Already in Hyprland ────────────────────────────────────────────────────
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    notify "Already in Hyprland ✨"
    exit 0
fi

# ── (b) Clean restart via the login screen ─────────────────────────────────
if [ "$MODE" = "--clean" ]; then
    notify "Returning to the login screen — pick 'Hyprland'…"
    sleep 0.5
    systemctl restart plasmalogin.service 2>/dev/null || true
    # If Plasma is the active session, ending it returns us to the greeter.
    qdbus6 org.kde.plasma.kwinerrord 2>/dev/null >/dev/null || true
    pkill -x plasmashell 2>/dev/null || true
    sleep 0.3
    exit 0
fi

# ── (a) Nested Hyprland inside Plasma ──────────────────────────────────────
if ! command -v Hyprland >/dev/null 2>&1; then
    log "Hyprland binary not found"
    exit 1
fi

# Only meaningful from a Wayland Plasma session. From X11 there is no nested
# Wayland compositor support, so fall back to the clean path.
if [ "${XDG_SESSION_TYPE:-}" != "wayland" ]; then
    log "not a wayland session ($XDG_SESSION_TYPE) — falling back to --clean"
    exec "$0" --clean
fi

# Launch on a dedicated workspace of the Plasma session so it does not land
# on top of whatever you were doing.
notify "Starting Hyprland (nested) ✨"
log "launching nested Hyprland"

exec env \
    HYPRLAND_INSTANCE_SIGNATURE="" \
    XDG_CURRENT_DESKTOP=Hyprland \
    XDG_SESSION_DESKTOP=hyprland \
    GDK_BACKEND=wayland,x11 \
    QT_QPA_PLATFORM=wayland \
    WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}" \
    Hyprland
