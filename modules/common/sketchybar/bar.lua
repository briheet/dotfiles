local colors = require("colors")
local settings = require("settings")

-- Let the wallpaper show through; only text and icons draw above it.
sbar.bar({
  position = "top",
  height = settings.height,
  color = colors.transparent,
  border_width = 0,
  shadow = false,
  sticky = true,
  topmost = "window",
  padding_left = 16,
  padding_right = 16,
})
