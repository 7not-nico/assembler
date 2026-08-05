-- r4_romsfun.lua — io edge: the romsfun tool operations (facade)
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Thin facade composing the deps: archive (verify), process (launch/stop),
-- trace (evidence), browser (readiness + bash delegation for browse/fetch
-- — Lua has no playwright driver). Each operation mirrors the canonical
-- bash tool. Constants from the schema — never hardcoded.
local r0 = require("r0_core")
local archive = require("deps.archive")
local browser = require("deps.browser")
local process = require("deps.process")
local trace = require("deps.trace")
local schema = require("schema")

local M = {}

-- browse — delegate to the canonical bash tool (no Lua playwright)
function M.browse(game, console)
  r0.validate_console(console)
  browser.assert_ready()
  local tpl = schema.templates_root
  local p = io.popen('bash ' .. tpl .. '/wrapper/browse-romsfun.sh ' ..
    '"' .. game .. '" ' .. '"' .. console .. '" 2>&1')
  local out = p:read("*a")
  p:close()
  return out
end

-- fetch — delegate to the canonical bash tool
function M.fetch(url)
  browser.assert_ready()
  local tpl = schema.templates_root
  local p = io.popen('bash ' .. tpl .. '/wrapper/fetch-download.sh "' .. url .. '" 2>&1')
  local out = p:read("*a")
  p:close()
  return out
end

-- verify — compose the archive deps
function M.verify(file, image_ext)
  local f = io.open(file, "r")
  if not f then error("no such file: " .. file, 2) end
  f:close()
  local ft = archive.file_type(file)
  if ft:find("Zip") or ft:find("zip") then
    local listing = archive.unzip_listing(file)
    local exts = nil
    if image_ext then
      exts = {}
      for e in image_ext:gmatch("[^,]+") do exts[e] = true end
    end
    local image = archive.first_image(listing, exts)
    if not image then error("no image inside archive", 2) end
    local size = archive.parse_size(archive.unzip_sizes(file), image)
    return { ok = image .. " (" .. size .. " B)", image = image, size = size }
  end
  if ft:find("ROM image") or ft:find("ISO") or ft:find("filesystem") then
    local size = tostring(archive.file_size(file))
    return { ok = "bare image (" .. size .. " B)", image = file, size = size }
  end
  error("unrecognized archive type: " .. ft:gsub("%s+$", ""), 2)
end

-- launch / stop — from the process dep
M.launch = process.launch
M.stop = process.stop

-- trace — from the trace dep
M.trace = trace.trace

return M
