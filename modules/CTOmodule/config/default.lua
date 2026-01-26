-- modules/CTOmodule/config/default.lua
-- Defaults; override by creating config/user.lua (same structure).

return {
  enabledByDefault = true,

  -- log
  logMaxLines = 200,

  -- tick loop
  tickIntervalMs = 500,      -- default tick interval
  tickAutoStart = false,     -- auto-start tick loop on init
  tickLogEvery = 0           -- 0 = no periodic tick log; e.g. 10 logs every 10 ticks
}
