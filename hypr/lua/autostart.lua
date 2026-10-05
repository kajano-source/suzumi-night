-- ═══════════════════════════════════════════════════════════════════════════
--  autostart.lua
--
--  Everything is funnelled through one shell script that is idempotent (safe
--  to re-run on every reload) and logs to /tmp/hypr-autostart.log:
--
--      ~/.config/hypr/scripts/autostart.sh
--
--  Keeping it in a script rather than a dozen hl.exec_cmd calls means a
--  half-dead daemon can be restarted by hand without editing this config.
-- ═══════════════════════════════════════════════════════════════════════════

local scripts = os.getenv("HOME") .. "/.config/hypr/scripts"

-- ── The main daemon starter ────────────────────────────────────────────────
hl.on("hyprland.start", function()
    hl.exec_cmd(scripts .. "/autostart.sh")
end)

-- ── Portals ────────────────────────────────────────────────────────────────
-- xdg-desktop-portal is the supervisor; the individual backends are started by
-- autostart.sh once the supervisor is up, because a backend that starts before
-- the supervisor just exits.
hl.exec_cmd("pkill -f 'xdg-desktop-portal-hyprland' 2>/dev/null; true")

-- ── Idle / lock daemon ─────────────────────────────────────────────────────
-- Started from autostart.sh so it can be restarted without a reload, but
-- make sure a stale one from a previous session is gone.
hl.exec_cmd("pkill -x hypridle 2>/dev/null; true")

-- ═══════════════════════════════════════════════════════════════════════════
--  REACTIONS — small behaviours that are nicer in Lua than in a shell script
-- ═══════════════════════════════════════════════════════════════════════════
--
--  Events available in 0.56.2 (from `hl.on`'s own error message):
--    hyprland.start              hyprland.shutdown
--    config.reloaded             config.props_refreshed
--    window.open  window.open_early  window.close  window.destroy
--    window.active  window.class  window.title  window.fullscreen
--    window.pin   window.urgent  window.kill    window.update_rules
--    workspace.created  workspace.removed  workspace.active
--    workspace.special_active  workspace.move_to_monitor
--    monitor.added  monitor.removed  monitor.focused  monitor.layout_changed
--    layer.opened   layer.closed
--    keybinds.submap  input.keyboard.key  screenshare.state
--
--  (There is deliberately no "hyprland.lock" event in 0.56 — the lock screen
--  is a session lock, not a Hyprland-managed surface.)

-- Re-assert the wallpaper when a layer (the lock screen) closes, so you never
-- come back to a black desktop.
-- (awww is Garuda's build of swww; there is no `swww msg` subcommand, so
--  `awww restore` is the closest thing to a "put my wallpaper back".)
hl.on("layer.closed", function()
    hl.exec_cmd("awww restore 2>/dev/null || true")
end)

-- Tell you the session came up cleanly, once a day at most.
hl.on("config.reloaded", function()
    hl.exec_cmd(scripts .. "/welcome.sh >/dev/null 2>&1 &")
end)
