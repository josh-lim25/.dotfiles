-- Gamma-2 (quadratic-mean) color blend, shared across the colorscheme specs.
--
-- Mirrors kanagawa-paper's own `Color:blend` (lib/color.lua):
--
--   out_channel = sqrt((1 - r) * accent^2 + r * base^2)
--
-- This is why its diff backgrounds are not the raw palette hexes: the
-- theme blends each accent into the editor bg at r = 0.9.
--
-- r in [0, 1]: r = 1 -> pure `base` (darkest), r = 0 -> pure `accent`
-- (most saturated). Lower r = stronger tint, higher r = closer to base.
local M = {}

---@param hex string "#rrggbb"
---@return number[] rgb 0-255
local function to_rgb(hex)
  hex = hex:gsub("#", "")
  return { tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16) }
end

--- Blend `accent` into `base` at ratio `r`.
---@param accent string hex color, e.g. "#699469"
---@param base string hex color, e.g. "#1F1F28"
---@param r number blend ratio in [0, 1]; higher = closer to `base`
---@return string hex color
function M.blend(accent, base, r)
  local a, b = to_rgb(accent), to_rgb(base)
  local out = {}
  for i = 1, 3 do
    out[i] = math.floor(math.sqrt((1 - r) * a[i] ^ 2 + r * b[i] ^ 2) + 0.5)
  end

  return string.format("#%02x%02x%02x", out[1], out[2], out[3])
end

return M
