-- ═══════════════════════════════════════════════════════════════════════════
--  workspaces.lua
--
--  Two named special workspaces:
--    scratchpad — a dock for windows you want out of the way (SUPER+C)
--    visualiser — where cava parks itself
--  plus a couple of "smart gap" single-window workspaces, declared in
--  rules.lua and referenced from the keybinds.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Named workspaces ───────────────────────────────────────────────────────
-- 98 = scratchpad, 99 = spare, 97 = visualiser.
hl.workspace_rule({ workspace = "w[1]",  default = true })
hl.workspace_rule({ workspace = "special:scratchpad" })
hl.workspace_rule({ workspace = "special:visualiser" })
hl.workspace_rule({ workspace = "special:spare" })

-- ── Default landing spot ───────────────────────────────────────────────────
hl.workspace_rule({ workspace = "w[1]", default = true })
