local colors = require("colors")
local settings = require("settings")

-- A single calm Nord surface gives titlebar-less windows a consistent edge.
-- The content groups provide hierarchy without turning every item into a pill.
sbar.bar({
  position = "top",
  height = settings.height,
  color = colors.bar,
  border_width = 0,
  shadow = false,
  sticky = true,
  topmost = "window",
  padding_left = 8,
  padding_right = 8,
})
