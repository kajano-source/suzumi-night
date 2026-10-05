-- ═══════════════════════════════════════════════════════════════════════════
--  look.lua · general + decoration + layouts
--
--  This is the single biggest contributor to the "rice" look: rounded
--  corners, a magenta -> violet -> indigo gradient border, violet drop
--  shadows, a real blur behind windows, and a violet glow around the
--  focused window.
--
--  All keys verified against Hyprland 0.56.2.
-- ═══════════════════════════════════════════════════════════════════════════

local t = require("lua.theme")

hl.config({
    -- ── Structure ──────────────────────────────────────────────────────────
    general = {
        gaps_in  = 6,
        gaps_out = 14,

        border_size = 2,

        -- The gradient border. This is the signature of the theme.
        col = {
            active_border   = t.border_gradient,
            inactive_border = t.border_inactive,
        },

        layout = "dwindle",

        resize_on_border        = true,
        extend_border_grab_area = 20,
        hover_icon_on_border    = true,
        resize_corner           = 0,
        float_gaps              = 2,

        -- "Smart gaps": no gaps when a workspace holds a single window.
        snap = {
            enabled       = true,
            window_gap    = 8,
            monitor_gap   = 6,
            border_overlap = true,
            respect_gaps  = true,
        },
    },

    -- ── Appearance ─────────────────────────────────────────────────────────
    decoration = {
        rounding       = 14,
        rounding_power = 2.0,      -- >1 = more "superelliptical" corners

        active_opacity     = 1.0,
        inactive_opacity   = 0.93,
        fullscreen_opacity = 1.0,

        -- Drop shadow, deep violet so it melts into the wallpaper.
        shadow = {
            enabled        = true,
            range          = 30,
            render_power   = 3,
            color          = t.c("0a0718", 0.85),
            color_inactive = t.c("0a0718", 0.45),
            offset         = { 0, 8 },
            scale          = -0.6,
            sharp          = 0,
        },

        -- A soft violet glow hugging the focused window.
        glow = {
            enabled      = true,
            range        = 22,
            render_power = 3,
            color        = t.c(t.violet, 0.35),
            color_inactive = t.c(t.violet, 0.0),
        },

        -- Behind-window blur. Vibrancy pushes the purple neon through.
        blur = {
            enabled            = true,
            size               = 7,
            passes             = 3,
            xray               = true,
            noise              = 0.012,
            contrast           = 1.05,
            brightness         = 0.98,
            vibrancy           = 0.2,
            vibrancy_darkness  = 0.35,
            new_optimizations  = true,
        },

        -- Slight dim on inactive windows instead of a hard opacity cut.
        dim_strength = 0.15,
    },

    -- ── Layout tuning ──────────────────────────────────────────────────────
    dwindle = {
        preserve_split         = true,
        force_split            = 2,
        smart_split            = false,
        smart_resizing         = true,
        permanent_direction_override = false,
        special_scale_factor   = 0.8,
        split_width_multiplier = 1.0,
        default_split_ratio    = 0.5,
        precise_mouse_move     = true,
        use_active_for_splits  = true,
    },

    master = {
        new_status           = "master",
        mfact                = 0.55,
        new_on_top           = false,
        new_on_active        = "slave",   -- string: master | slave | inherit
        allow_small_split    = false,
        special_scale_factor = 0.85,
        drop_at_cursor       = true,
        smart_resizing       = true,
        orientation          = "left",
    },

    -- ── Groups (tabbed windows) ────────────────────────────────────────────
    group = {
        auto_group                      = true,
        drag_into_group                 = true,
        focus_removed_window            = true,
        merge_groups_on_drag            = true,
        group_on_movetoworkspace        = true,
        insert_after_current            = true,
        col = {
            border_active   = t.c(t.magenta),
            border_inactive = t.c(t.border, 0.75),
        },
        groupbar = {
            enabled             = true,
            font_family         = "JetBrainsMono Nerd Font",
            font_size           = 9,
            font_weight_active  = "bold",
            font_weight_inactive = "normal",
            height              = 24,
            rounding            = 10,
            rounding_power      = 2.0,
            text_color          = t.c(t.text),
            text_color_inactive = t.c(t.dim),
            text_padding        = 8,
            text_offset         = 0,
            gradients           = false,
            render_titles       = true,
            disable_when_only   = true,
        },
    },

    -- ── Scrolling layout (available if you want it later) ──────────────────
    scrolling = {
        fullscreen_on_one_column = true,
    },

    -- ── Rendering (Intel Iris Xe) ──────────────────────────────────────────
    render = {
        direct_scanout         = true,
        new_render_scheduling   = true,
        commit_timing_enabled  = true,
    },

    -- ── Misc ───────────────────────────────────────────────────────────────
    misc = {
        focus_on_activate       = true,
        key_press_enables_dpms  = true,
        mouse_move_enables_dpms = true,
        vrr                     = 0,        -- panel reports VRR incapable
        allow_session_lock_restore = true,
        disable_autoreload      = false,
        disable_watchdog_warning = true,
        enable_swallow          = true,
        swallow_regex           = "kitty,foot,alacritty,gnome-terminal",
        middle_click_paste      = true,
        background_color        = t.c(t.base, 1.0),
        font_family             = "JetBrainsMono Nerd Font",
    },
})
