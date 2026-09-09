local colors = require("colors")
local settings = require("settings")

-- Do not show nonfunctional workspace controls on hosts without AeroSpace.
if not require("features").aerospace then
  return
end

sbar.add("event", "aerospace_workspace_change")

local spaces = {}

local function select_workspace(focused)
  focused = tostring(focused or ""):gsub("%s+", "")

  for sid, item in pairs(spaces) do
    local selected = sid == focused
    sbar.animate("tanh", 12, function()
      item:set({
        label = {
          color = selected and colors.accent or colors.text_muted,
        },
      })
    end)
  end
end

for index = 1, 9 do
  local sid = tostring(index)
  local name = "space." .. sid
  local item = sbar.add("item", name, {
    position = "left",
    width = 25,
    padding_left = 1,
    padding_right = 1,
    icon = { drawing = false },
    label = {
      string = sid,
      align = "center",
      width = 25,
      padding_left = 0,
      padding_right = 0,
      font = {
        family = settings.label_font,
        style = "Bold",
        size = 11.0,
      },
      color = colors.text_muted,
    },
    background = {
      color = colors.transparent,
      height = 26,
      corner_radius = 6,
    },
  })

  item:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. sid)
  end)

  spaces[sid] = item
end

local observer = sbar.add("item", "space.observer", {
  drawing = false,
  updates = true,
  update_freq = 30,
})

observer:subscribe("aerospace_workspace_change", function(env)
  select_workspace(env.FOCUSED_WORKSPACE)
end)

observer:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("aerospace list-workspaces --focused 2>/dev/null", function(output, exit_code)
    select_workspace(exit_code == 0 and output or "")
  end)
end)
