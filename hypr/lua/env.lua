-- ═══════════════════════════════════════════════════════════════════════════
--  env.lua · environment variables
--
--  Hyprland's own launcher (`start-hyprland`, which is what the "Hyprland"
--  entry in the login screen runs) sets almost nothing. Everything below is
--  what makes GTK4/Qt/Electron apps behave inside a Wayland session, so it
--  has to be set here rather than in the login manager.
--
--  Set in ~/.config/environment.d/ as well (see the comment there) so the
--  KDE Plasma session gets the same treatment — that is the other half of
--  "switch between Hyprland and Plasma without surprises".
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Session identity ───────────────────────────────────────────────────────
-- Without this, GTK/Qt apps think they are running under some other DE and
-- several refuse to start (or open with no title bar).
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP",  "hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")

-- ── Toolkit backends ───────────────────────────────────────────────────────
-- Prefer native Wayland everywhere; fall back to XWayland only if the app
-- has no Wayland support at all.
hl.env("GDK_BACKEND", "wayland,x11")

hl.env("QT_QPA_PLATFORM", "wayland")
-- Use the GTK3 theme for Qt apps so they match the rest of the desktop
-- instead of looking like stock Qt.
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
-- We handle scaling ourselves; letting Qt guess produces mismatched sizes.
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "0")

-- ── Firefox ────────────────────────────────────────────────────────────────
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("MOZ_DBUS_REMOTE", "1")
hl.env("MOZ_WAYLAND_USE_VAAPI", "1")

-- ── Java / Electron / SDL ──────────────────────────────────────────────────
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("NO_AT_BRIDGE", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- ── Cursor ─────────────────────────────────────────────────────────────────
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ── FZF, to match the rest of the palette ──────────────────────────────────
hl.env("FZF_DEFAULT_OPTS", table.concat({
    "--color=bg+:-1,bg:#1e1e2e,fg:#ece3fb,hl:#f472d0",
    "--color=fg+:#b3a3d6,header:#f472d0,info:#c9a7f5,pointer:#ece3fb",
    "--color=marker:#8b5cf6,spinner:#7ad7f5,header-border:none",
}, " "))
