-- ═══════════════════════════════════════════════════════════════════════════
--  input.lua · keyboard, touchpad, gestures
--
--  Verified against Hyprland 0.56.2. Options removed in 0.55/0.56 and so
--  absent here on purpose:
--    input:force_no_altgr
--    input:touchpad:two_finger_scroll
--    input:touchpad:edge_scroll
--    input:touchpad:middle_click_emulation   (renamed middle_button_emulation)
--
--  Note the Lua key for tap-to-click is `tap_to_click` (underscores) even
--  though the legacy hyprlang name used a dash.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Keyboard ───────────────────────────────────────────────────────────────
-- `us` matches your Garuda/Mokka setup. Swap kb_layout (and kb_variant) if
-- you type something other than English: gb, de, fr, es, ...
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",

        follow_mouse = 1,
        sensitivity  = 0,          -- -1.0 .. 1.0, 0 = unmodified

        numlock_by_default = true,
        repeat_rate        = 50,
        repeat_delay       = 300,

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            tap_to_click         = true,
            clickfinger_behavior = true,
            scroll_factor        = 1.0,
        },
    },
})

-- ── Touchpad gestures ──────────────────────────────────────────────────────
-- 3-finger horizontal swipe = next/previous workspace.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- 4-finger pinch-in closes the focused window.
hl.gesture({ fingers = 4, direction = "pinch", action = "close" })

-- ── Cursor ─────────────────────────────────────────────────────────────────
hl.config({
    cursor = {
        no_hardware_cursors = true,   -- needed for the smooth software cursor
        no_break_fs_vrr     = true,
        min_refresh_rate   = 24,
        inactive_timeout   = 5,
        no_warps           = false,
        enable_hyprcursor  = true,
        hide_on_key_press  = true,
    },
})
