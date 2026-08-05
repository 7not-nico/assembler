-- deps/process.lua — shared process dependency: launch + stop
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Mirrors launch-emulator.sh + stop-process.sh: detached launch with a
-- health check, and exact-binary-name stop.
local schema = require("schema")

local M = {}

function M.launch(binary, rom, log)
  local rf = io.open(rom, "r")
  if not rf then error("no such ROM: " .. rom, 2) end
  rf:close()
  log = log or schema.LAUNCH_LOG
  local cmd = string.format(
    "setsid nohup %q %q >%q 2>&1 </dev/null & echo $!",
    binary, rom, log
  )
  local p = io.popen(cmd)
  local pid = p:read("*a"):match("%d+")
  p:close()
  os.execute("sleep 2")
  local alive = io.popen("kill -0 " .. pid .. " 2>/dev/null; echo $?"):read("*a"):match("0%s*$")
  if not alive then error("emulator exited early — see " .. log, 2) end
  return pid
end

function M.stop(binary_name)
  local p = io.popen("pgrep -x " .. binary_name .. " 2>/dev/null")
  local pids = p:read("*a")
  p:close()
  if pids == "" then return 0 end
  for pid in pids:gmatch("%d+") do
    os.execute("kill " .. pid .. " 2>/dev/null")
  end
  return 1
end

return M
