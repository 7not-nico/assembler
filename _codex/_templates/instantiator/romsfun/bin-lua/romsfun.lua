-- romsfun.lua — typed-functional romsfun toolchain entry
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Dispatch only — composes r0 (pure core) + r4 (io edge). Subcommands:
--   browse {game} {console}
--   fetch  {url}
--   verify {file} [--image-ext exts]
--   launch {binary} {rom} [--log PATH]
--   stop   {binary-name}
--   trace  {trace-file} [--head N]
package.path = "./?.lua;./deps/?.lua;" .. package.path

local r4 = require("r4_io")

local function usage()
  io.stderr:write("usage: romsfun {browse|fetch|verify|launch|stop|trace} ...\n")
  os.exit(2)
end

-- flag_value {args} {flag} — the value after a --flag, or nil. Pure.
local function flag_value(rest, flag)
  for i = 1, #rest do
    if rest[i] == flag then return rest[i + 1] end
  end
  return nil
end

local function main(argv)
  if #argv == 0 then usage() end
  local sub = argv[1]
  local rest = {}
  for i = 2, #argv do rest[#rest + 1] = argv[i] end
  local ok, err = pcall(function()
    if sub == "browse" then
      if #rest < 2 then usage() end
      io.write(r4.browse(rest[1], rest[2]))
    elseif sub == "fetch" then
      if #rest < 1 then usage() end
      io.write(r4.fetch(rest[1]))
    elseif sub == "verify" then
      if #rest < 1 then usage() end
      local r = r4.verify(rest[1], flag_value(rest, "--image-ext"))
      io.write(string.format("OK   %s\nIMAGE=%s\nSIZE=%s\n", r.ok, r.image, r.size))
    elseif sub == "launch" then
      if #rest < 2 then usage() end
      local pid = r4.launch(rest[1], rest[2], flag_value(rest, "--log"))
      io.write(string.format("LAUNCH %s %s\nRUN   pid=%s\n", rest[1], rest[2], pid))
    elseif sub == "stop" then
      if #rest < 1 then usage() end
      io.write("STOPPED=" .. r4.stop(rest[1]) .. "\n")
    elseif sub == "trace" then
      if #rest < 1 then usage() end
      local head = tonumber(flag_value(rest, "--head"))
      local r = r4.trace(rest[1], head)
      io.write(string.format("TRACE=%s\nLINES=%d\n", rest[1], r.lines))
      for i = 1, math.min(5, #r.evidence) do io.write("HEAD " .. r.evidence[i] .. "\n") end
    else
      io.stderr:write("unknown subcommand: " .. sub .. "\n")
      os.exit(2)
    end
  end)
  if not ok then
    io.stderr:write("ERROR " .. err .. "\n")
    os.exit(1)
  end
end

main({...})
