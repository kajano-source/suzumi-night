#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  autostart.sh — start every Hyprland daemon exactly once.
#  Idempotent: safe to re-run on `hyprctl reload`.
#  Log: /tmp/hypr-autostart.log
#
#  ⚠ Garuda ships swww as `awww` (An Answer to Your Wayland Wallpaper Woes).
#    The package "Provides: swww" but the binaries are /usr/bin/awww and
#    /usr/bin/awww-daemon, and the CLI differs slightly from upstream swww:
#      • --resize takes no|crop|fit|stretch   (swww called this "cover")
#      • there is no `swww msg` subcommand, so no "flash" transition
#    Everything here uses awww.
# ═══════════════════════════════════════════════════════════════════════════
set -u

LOG=/tmp/hypr-autostart.log
CFG="$HOME/.config/hypr"
RICE="$HOME/.local/share/hypr-rice"
export PATH="$HOME/.local/bin:$PATH"

log() { printf '%s %s\n' "$(date +%T)" "$*" >>"$LOG"; }

# Run only if the process isn't already alive, then confirm it actually came
# up. Reporting "started" for something that died immediately is worse than
# useless when you are trying to work out why a session looks half-alive.
once() {
    local name="$1"; shift
    if pgrep -x "$name" >/dev/null 2>&1; then
        log "skip   $name (already running)"
        return 0
    fi
    "$@" >>"$LOG" 2>&1 &
    sleep 0.4
    if pgrep -x "$name" >/dev/null 2>&1; then
        log "start  $name"
    else
        log "FAIL   $name (exited immediately — reason above)"
    fi
}

log "---- autostart $(date) ----"

# ── Wallpaper ──────────────────────────────────────────────────────────────
if pgrep -x awww-daemon >/dev/null 2>&1; then
    log "skip   awww-daemon (already running)"
else
    awww-daemon >>"$LOG" 2>&1 &
    log "start  awww-daemon"
    sleep 0.5   # the daemon needs a moment before it will accept an image
fi
awww img "$RICE/suzumi-4k.jpg" \
    --resize crop \
    --transition-type any \
    --transition-fps 60 \
    --transition-duration 1.2 >>"$LOG" 2>&1
log "wall   suzumi-4k.jpg"

# ── Bar ────────────────────────────────────────────────────────────────────
once waybar waybar

# ── Notifications ──────────────────────────────────────────────────────────
once mako mako

# ── Portals ────────────────────────────────────────────────────────────────
once xdg-desktop-portal          xdg-desktop-portal
once xdg-desktop-portal-hyprland xdg-desktop-portal-hyprland
once xdg-desktop-portal-gtk      xdg-desktop-portal-gtk

# ── Polkit agent ───────────────────────────────────────────────────────────
# hyprpolkitagent matches the rice; polkit-kde-agent is the fallback so
# mounting disks and changing power settings still works without it.
if command -v hyprpolkitagent >/dev/null 2>&1; then
    once hyprpolkitagent hyprpolkitagent
elif command -v polkit-gnome-authentication-agent-1 >/dev/null 2>&1; then
    once polkit-gnome-authentication-agent-1 polkit-gnome-authentication-agent-1
else
    once polkit-kde-agent polkit-kde-agent
fi

# ── Clipboard manager ──────────────────────────────────────────────────────
if command -v cliphist >/dev/null 2>&1; then
    if ! pgrep -f 'wl-paste.*cliphist' >/dev/null 2>&1; then
        wl-paste --type text  --watch cliphist store >/dev/null 2>&1 &
        wl-paste --type image --watch cliphist store >/dev/null 2>&1 &
        log "start  cliphist (text+image watchers)"
    else
        log "skip   cliphist (already running)"
    fi
fi

# ── Idle / lock ────────────────────────────────────────────────────────────
once hypridle hypridle

# ── Remember the volume across sessions ────────────────────────────────────
if command -v wpctl >/dev/null 2>&1; then
    mkdir -p "$HOME/.cache"
    (
        while true; do
            wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null \
                | awk '{print $2}' | tr -d '%' \
                > "$HOME/.cache/hypr-volume"
            sleep 4
        done
    ) >/dev/null 2>&1 &
    log "start  volume-persist"
fi

log "---- done ----"
exit 0
