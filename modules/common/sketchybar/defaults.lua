local colors = require("colors")
local settings = require("settings")

sbar.default({
  updates = "when_shown",
  padding_left = settings.gap,
  padding_right = settings.gap,
  icon = {
    font = {
      family = settings.font,
      style = "Bold",
      size = 13.0,
    },
    color = colors.text_muted,
    padding_left = 5,
    padding_right = 4,
  },
  label = {
    font = {
      family = settings.font,
      style = "Medium",
      size = 12.0,
    },
    color = colors.text,
    padding_left = 3,
    padding_right = 5,
  },
  background = {
    drawing = false,
    height = settings.item_height,
    corner_radius = settings.radius,
  },
  popup = {
    background = {
      color = colors.nord0,
      border_color = colors.border,
      border_width = 1,
      corner_radius = settings.radius,
    },
    blur_radius = 20,
  },
})
