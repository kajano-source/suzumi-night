#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  powermenu.sh — wofi power menu (SUPER+P)
#    lock · suspend · hibernate · reboot · shutdown · log out · switch DE
# ═══════════════════════════════════════════════════════════════════════════
set -u

CFG="$HOME/.config/hypr"

run() {
    case "$1" in
        lock)
            "$CFG/scripts/lock.sh" &
            ;;
        suspend)
            makoctl dismiss 2>/dev/null
            hyprlock 2>/dev/null   # will be replaced by the screen going off
            sleep 0.4
            systemctl suspend
            ;;
        hibernate)
            makoctl dismiss 2>/dev/null
            hyprlock 2>/dev/null
            sleep 0.4
            systemctl hibernate
            ;;
        reboot)
            makoctl dismiss 2>/dev/null
            hyprlock 2>/dev/null
            sleep 0.4
            systemctl reboot
            ;;
        shutdown)
            makoctl dismiss 2>/dev/null
            hyprlock 2>/dev/null
            sleep 0.4
            systemctl poweroff
            ;;
        logout)
            makoctl dismiss 2>/dev/null
            hyprlock 2>/dev/null
            sleep 0.4
            hyprctl dispatch exit
            ;;
        plasma)
            "$CFG/scripts/switch-to-plasma.sh" &
            ;;
        hyprland)
            "$CFG/scripts/switch-to-hyprland.sh" &
            ;;
    esac
}

ENTRIES=(
    "󰐥  Lock            SUPER+L"
    "󰓪  Suspend"
    "󰊢  Hibernate"
    "󰖥  Switch to KDE Plasma    SUPER+SHIFT+ESC"
    "󰓤  Switch to Hyprland"
    "󰍉  Log out of Hyprland"
    "󰁔  Reboot"
    "󰐥  Shut down"
)

CHOICE=$(printf '%s\n' "${ENTRIES[@]}" | wofi \
    --dmenu \
    --insensitive \
    --prompt "Power ▸ " \
    -h scrollbar:yes \
    -h row_padding=8 \
    -h xspacing=12)

[ -z "${CHOICE:-}" ] && exit 0

# Map the chosen row back to an action.
case "$CHOICE" in
    *Lock*)               run lock       ;;
    *Suspend*)            run suspend    ;;
    *Hibernate*)          run hibernate  ;;
    *KDE\ Plasma*)        run plasma     ;;
    *Hyprland*)           run hyprland   ;;
    *"Log out"*)          run logout     ;;
    *Reboot*)             run reboot     ;;
    *Shut\ down*)         run shutdown   ;;
esac
