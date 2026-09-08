local colors = require("colors")

local M = {}

function M.trim(value)
  return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

function M.hover(item, normal_color)
  item:subscribe("mouse.entered", function()
    sbar.animate("tanh", 10, function()
      item:set({ icon = { color = colors.accent } })
    end)
  end)

  item:subscribe("mouse.exited", function()
    sbar.animate("tanh", 10, function()
      item:set({ icon = { color = normal_color or colors.text_muted } })
    end)
  end)
end

return M
