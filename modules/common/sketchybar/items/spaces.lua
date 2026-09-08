local colors = require("colors")
local settings = require("settings")

sbar.add("event", "aerospace_workspace_change")

local spaces = {}
local members = {}

local function select_workspace(focused)
  focused = tostring(focused or ""):gsub("%s+", "")

  for sid, item in pairs(spaces) do
    local selected = sid == focused
    sbar.animate("tanh", 12, function()
      item:set({
        label = {
          color = selected and colors.nord0 or colors.text_muted,
        },
        background = {
          drawing = selected,
          color = colors.accent,
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
      padding_left = 0,
      padding_right = 0,
      font = {
        family = settings.font,
        style = "Bold",
        size = 12.0,
      },
      color = colors.text_muted,
    },
    background = {
      drawing = false,
      color = colors.accent,
      height = 22,
      corner_radius = 7,
    },
  })

  item:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. sid)
  end)

  spaces[sid] = item
  table.insert(members, name)
end

sbar.add("bracket", "spaces", members, {
  background = {
    drawing = true,
    color = colors.surface,
    border_color = colors.border,
    border_width = 1,
    height = 28,
    corner_radius = 9,
  },
})

local observer = sbar.add("item", "space.observer", {
  drawing = false,
  updates = true,
})

observer:subscribe("aerospace_workspace_change", function(env)
  select_workspace(env.FOCUSED_WORKSPACE)
end)

observer:subscribe("forced", function()
  sbar.exec("aerospace list-workspaces --focused", function(output)
    select_workspace(output)
  end)
end)
