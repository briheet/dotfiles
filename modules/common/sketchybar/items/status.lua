local colors = require("colors")
local helpers = require("helpers")
local icons = require("icons")
local settings = require("settings")

local members = {}

local function add_member(name)
  table.insert(members, name)
end

-- Network is deliberately icon-only. The SSID belongs in a click target, not
-- in the bar's permanent visual hierarchy.
local network = sbar.add("item", "status.network", {
  position = "right",
  update_freq = 60,
  icon = {
    string = icons.wifi.connected,
    color = colors.nord9,
  },
  label = { drawing = false },
})
add_member("status.network")

local function update_network()
  sbar.exec("ipconfig getifaddr en0", function(address, exit_code)
    local connected = exit_code == 0 and helpers.trim(address) ~= ""
    network:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and colors.nord9 or colors.nord11,
      },
    })
  end)
end

network:subscribe({ "routine", "wifi_change", "system_woke", "forced" }, update_network)
network:subscribe("mouse.clicked", function()
  sbar.exec("open 'x-apple.systempreferences:com.apple.wifi-settings-extension'")
end)

local volume = sbar.add("item", "status.volume", {
  position = "right",
  icon = {
    string = icons.volume.medium,
    color = colors.nord7,
  },
  label = {
    string = "--",
    width = 27,
    align = "right",
    color = colors.text_muted,
  },
})
add_member("status.volume")

local function set_volume(value)
  local level = tonumber(value) or 0
  local icon = icons.volume.muted
  if level >= 60 then
    icon = icons.volume.high
  elseif level >= 30 then
    icon = icons.volume.medium
  elseif level > 0 then
    icon = icons.volume.low
  end

  volume:set({
    icon = { string = icon },
    label = { string = tostring(math.floor(level)) },
  })
end

volume:subscribe("volume_change", function(env)
  set_volume(env.INFO)
end)
volume:subscribe("forced", function()
  sbar.exec("osascript -e 'output volume of (get volume settings)'", set_volume)
end)
volume:subscribe("mouse.clicked", function()
  sbar.exec("osascript -e 'set volume output muted not (output muted of (get volume settings))'")
end)

local battery = sbar.add("item", "status.battery", {
  position = "right",
  update_freq = 120,
  icon = {
    string = icons.battery.high,
    color = colors.nord14,
  },
  label = {
    string = "--%",
    width = 34,
    align = "right",
    color = colors.text_muted,
  },
})
add_member("status.battery")

local function update_battery()
  sbar.exec("pmset -g batt", function(info)
    local percentage = tonumber((info or ""):match("(%d+)%%"))
    if not percentage then
      battery:set({ drawing = false })
      return
    end

    local charging = (info or ""):find("AC Power", 1, true) ~= nil
    local icon = icons.battery.empty
    local color = colors.nord11

    if charging then
      icon = icons.battery.charging
      color = colors.nord14
    elseif percentage > 85 then
      icon = icons.battery.full
      color = colors.nord14
    elseif percentage > 60 then
      icon = icons.battery.high
      color = colors.nord7
    elseif percentage > 35 then
      icon = icons.battery.medium
      color = colors.nord7
    elseif percentage > 15 then
      icon = icons.battery.low
      color = colors.nord13
    end

    battery:set({
      drawing = true,
      icon = { string = icon, color = color },
      label = { string = tostring(percentage) .. "%" },
    })
  end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke", "forced" }, update_battery)
battery:subscribe("mouse.clicked", function()
  sbar.exec("open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'")
end)

local clock = sbar.add("item", "status.clock", {
  position = "right",
  update_freq = 10,
  icon = {
    string = "",
    color = colors.text_muted,
    font = {
      family = settings.font,
      style = "Medium",
      size = 11.0,
    },
  },
  label = {
    string = "--:--",
    color = colors.text,
    font = {
      family = settings.font,
      style = "Bold",
      size = 12.0,
    },
  },
})
add_member("status.clock")

local function update_clock()
  clock:set({
    icon = { string = os.date("%a %d") },
    label = { string = os.date("%H:%M") },
  })
end

clock:subscribe({ "routine", "forced", "system_woke" }, update_clock)
clock:subscribe("mouse.clicked", function()
  sbar.exec("open -a Calendar")
end)

sbar.add("bracket", "status", members, {
  background = {
    drawing = true,
    color = colors.surface,
    border_color = colors.border,
    border_width = 1,
    height = 28,
    corner_radius = 9,
  },
})
