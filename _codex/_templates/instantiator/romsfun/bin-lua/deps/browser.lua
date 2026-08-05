-- deps/browser.lua — shared browser dependency: readiness probe
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Mirrors deps/browser.sh: proves the shared Chromium stack is usable via
-- the shared portup Go binary. Lua has no playwright driver, so browse/fetch
-- shell out to the canonical tools after this readiness check.
local schema = require("schema")

local M = {}

function M.cdp_endpoint()
  local port = os.getenv("CDP_PORT") or schema.value("CDP_PORT_HEADED")
  return "http://127.0.0.1:" .. port
end

function M.assert_ready()
  local port = os.getenv("CDP_PORT") or schema.value("CDP_PORT_HEADED")
  local bin = os.getenv("SHARED_BIN") or (schema.templates_root .. "/_shared/bin")
  local p = io.popen(bin .. "/portup " .. port .. " 2>/dev/null; echo $?")
  local ok = p:read("*a"):match("0%s*$")
  p:close()
  if not ok then
    error("shared browser not running — start it: bash " ..
      schema.templates_root .. "/shell/start-browser.sh", 2)
  end
  return M.cdp_endpoint()
end

return M
