-- deps/archive.lua — shared archive dependency: probe + listing
-- purity: io
-- ring: 4 (LOCAL-WRITE)
-- Mirrors deps/archive.sh + the Python/TS ports: file-type detection and
-- archive listing for verify/acquire. Pure transforms compose the io
-- probes (io.popen).
local r0 = require("r0_core")

local M = {}

function M.file_type(file)
  local p = io.popen('file -b "' .. file .. '" 2>/dev/null')
  local out = p:read("*a")
  p:close()
  return out
end

function M.unzip_listing(archive)
  local p = io.popen('unzip -Z1 "' .. archive .. '" 2>/dev/null')
  local out = p:read("*a")
  p:close()
  local lines = {}
  for line in out:gmatch("[^\n]+") do
    if line ~= "" then lines[#lines + 1] = line end
  end
  return lines
end

function M.unzip_sizes(archive)
  local p = io.popen('unzip -l "' .. archive .. '" 2>/dev/null')
  local out = p:read("*a")
  p:close()
  return out
end

function M.first_image(listing, exts)
  for _, line in ipairs(listing) do
    local lower = line:lower()
    if exts then
      for e in pairs(exts) do
        if lower:sub(-#e) == e then return line end
      end
    elseif r0.is_image(line) then
      return line
    end
  end
  return nil
end

function M.parse_size(unzip_out, image)
  -- Lua $ is not multiline — match per line. Anchor size at line start,
  -- then date (12-24-1996) + time (23:32) + image.
  local esc = image:gsub("([%.%+%-%*%?%[%]%(%)%^%$])", "%%%1")
  for line in unzip_out:gmatch("[^\n]+") do
    local size = line:match(
      "^%s*(%d+)%s+%d%d?%-%d%d?%-%d%d%d%d%s+%d%d?:%d%d%s+" .. esc .. "%s*$"
    )
    if size then return size end
  end
  return ""
end

function M.file_size(file)
  local p = io.popen('stat -c%s "' .. file .. '" 2>/dev/null')
  local n = p:read("*a")
  p:close()
  return tonumber(n) or 0
end

return M
