#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
#  open-dashboard.sh — start suzumi-dashboard if needed, then open a browser
#
#  Bound to the "System Dashboard" entry in the Hyprland menu.
# ═══════════════════════════════════════════════════════════════════════════
set -u

APP="$HOME/Projects/suzumi-dashboard/server.py"
URL="http://127.0.0.1:8787/"

# Already serving?  Then just show it.
if curl -sf -m 2 "$URL" >/dev/null 2>&1; then
    exec xdg-open "$URL"
fi

[ -f "$APP" ] || {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a "Dashboard" "Suzumi Night" "not found: $APP" 2>/dev/null
    echo "suzumi-dashboard not found at $APP" >&2
    exit 1
}

# Detach fully, or the keybind's process group waits on the server forever.
setsid python3 "$APP" >"$HOME/.cache/suzumi-dashboard.log" 2>&1 < /dev/null &
disown 2>/dev/null || true

# Wait for it to answer before pointing a browser at it.
for _ in $(seq 1 20); do
    sleep 0.25
    curl -sf -m 1 "$URL" >/dev/null 2>&1 && break
done

if curl -sf -m 2 "$URL" >/dev/null 2>&1; then
    exec xdg-open "$URL"
fi

command -v notify-send >/dev/null 2>&1 && \
    notify-send -a "Dashboard" "Suzumi Night" "server did not start — see ~/.cache/suzumi-dashboard.log" 2>/dev/null
echo "dashboard did not come up; see ~/.cache/suzumi-dashboard.log" >&2
exit 1
