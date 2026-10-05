#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  easter-egg.sh — SUPER+U
#  Prints the config map. Genuinely useful the first week, mildly amusing
#  after that.
# ═══════════════════════════════════════════════════════════════════════════
set -u

FONT="JetBrainsMono Nerd Font"
C_RESET=$'\e[0m'; C_DIM=$'\e[2m'; C_B=$'\e[1m'
P=$'\e[38;5;213m'   # pink
V=$'\e[38;5;141m'   # violet
L=$'\e[38;5;189m'   # lavender
Y=$'\e[38;5;222m'   # yellow

banner() {
  cat <<'EOF'
 ██████╗ ██╗   ██╗███████╗██╗   ██╗███╗   ███╗██╗
██╔═══██╗██║   ██║██╔════╝██║   ██║████╗ ████║██║
██║   ██║██║   ██║███████╗██║   ██║██╔████╔██║██║
██║   ██║╚██╗ ██╔╝╚════██║██║   ██║██║╚██╔╝██║██║
╚██████╔╝ ╚████╔╝ ██████╗╝╚██████╔╝██║ ╚═╝ ██║██║
 ╚═════╝   ╚═══╝  ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝
EOF
}

if ! command -v wofi >/dev/null 2>&1; then
    banner
    exit 0
fi

HELP=$(cat <<'EOF'
━━━ LAUNCH ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + Return      terminal (kitty)
SUPER + D           menu  (apps + rice actions)
SUPER + E           file manager
SUPER + T           editor
SUPER + V           app grid
SUPER + Space       clipboard history
SUPER + X           calculator

━━━ WINDOWS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + Q           close            SUPER + F      fullscreen
SUPER + V(shift)    float            SUPER + M      dwindle ↔ master
SUPER + H J K L     focus  ← ↓ ↑ →  SUPER + I      pin (floating)
SUPER + H J K L + shift    move window
SUPER + H J K L + alt      resize window
SUPER + G / A / Z   move to corner
SUPER + C           scratchpad       SUPER + Y      colour picker

━━━ WORKSPACES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + 1…0         jump             SUPER + shift + 1…0   send window
SUPER + shift + [ ] take window with you
SUPER + scroll      prev/next        3-finger swipe too

━━━ SYSTEM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + S           screenshot area  SUPER + shift + S  whole screen
SUPER + alt + S     screenshot window
SUPER + B           show/hide bar    SUPER + W       wallpaper picker
SUPER + alt + A     live wallpaper toggle
SUPER + L           lock screen      SUPER + P       power menu
SUPER + shift + R   reload config
SUPER + M + alt     animations on/off
SUPER + U           this cheat sheet

━━━ SESSIONS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER + shift + ESC   → hand back to KDE Plasma
SUPER + alt   + ESC   → (from Plasma) start Hyprland
SUPER + D  → "Switch to KDE Plasma" / "Switch to Hyprland"
EOF
)

printf '%s\n' "$HELP" | wofi --dmenu --insensitive --prompt "Keybinds ▸ " -h row_padding=6
