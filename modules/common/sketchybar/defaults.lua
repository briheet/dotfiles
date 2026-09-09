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
      size = 11.0,
    },
    color = colors.text_muted,
    shadow = { drawing = true, color = 0xb0000000, angle = 270, distance = 1 },
    y_offset = settings.icon_y_offset,
    padding_left = 3,
    padding_right = 2,
  },
  label = {
    font = {
      family = settings.label_font,
      style = "Medium",
      size = 11.0,
    },
    color = colors.text,
    shadow = { drawing = true, color = 0xb0000000, angle = 270, distance = 1 },
    y_offset = settings.label_y_offset,
    padding_left = 2,
    padding_right = 3,
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
