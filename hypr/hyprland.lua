-- ═══════════════════════════════════════════════════════════════════════════
--  HYPRLAND · "Suzumi Night"
--  Garuda Linux · i5-1235U · Intel Iris Xe · eDP-1 1920x1080@60
--
--  Entry point. Everything else lives in lua/ and is pulled in with
--  require(), in dependency order:
--
--      theme.lua        the colour scheme (sampled from the wallpaper)
--      env.lua          environment variables for GTK/Qt/Java/SDL
--      monitor.lua      outputs + scale
--      input.lua        keyboard, touchpad, gestures, cursor
--      look.lua         general + decoration + layout tuning
--      animations.lua   curves, springs and the animation leaves
--      workspaces.lua   named / special workspaces
--      rules.lua        window + layer rules
--      binds.lua        keybinds
--      autostart.lua    daemons
--
--  Reload after editing with  SUPER + R  (or: hyprctl reload)
--
--  Validate without starting a session:
--      Hyprland --verify-config
-- ═══════════════════════════════════════════════════════════════════════════

require("lua.theme")
require("lua.env")
require("lua.monitor")
require("lua.input")
require("lua.look")
require("lua.animations")
require("lua.workspaces")
require("lua.rules")
require("lua.binds")
require("lua.autostart")
