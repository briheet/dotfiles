local colors = require("colors")
local helpers = require("helpers")
local icons = require("icons")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  padding_left = 10,
  padding_right = 6,
  icon = {
    string = icons.app,
    color = colors.nord9,
    padding_left = 0,
  },
  label = {
    string = "Desktop",
    max_chars = 24,
    color = colors.text,
  },
})

local function set_app(name)
  name = helpers.trim(name)
  front_app:set({ label = { string = name ~= "" and name or "Desktop" } })
end

front_app:subscribe("front_app_switched", function(env)
  set_app(env.INFO)
end)

front_app:subscribe("forced", function()
  sbar.exec(
    "osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'",
    set_app
  )
end)

helpers.hover(front_app, colors.nord9)
