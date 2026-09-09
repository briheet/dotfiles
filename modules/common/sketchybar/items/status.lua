local colors = require("colors")
local helpers = require("helpers")
local icons = require("icons")
local settings = require("settings")

-- Right-side items are created from right to left; the clock anchors the edge.
local clock = sbar.add("item", "status.clock", {
  -- Keep the date and time clear of the MacBook's centered camera notch.
  position = "right",
  update_freq = 10,
  icon = {
    string = "",
    color = colors.text_muted,
    font = {
      family = settings.label_font,
      style = "Medium",
      size = 11.0,
    },
  },
  label = {
    string = "--:--",
    color = colors.text,
    font = {
      family = settings.label_font,
      style = "Bold",
      size = 11.0,
    },
  },
})

local function update_clock()
  clock:set({
    icon = { string = os.date("%a, %d %b") },
    label = { string = os.date("%H:%M") },
  })
end

clock:subscribe({ "routine", "forced", "system_woke" }, update_clock)
clock:subscribe("mouse.clicked", function()
  sbar.exec("open -a Calendar")
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
    width = "dynamic",
    align = "left",
    color = colors.text_muted,
  },
})

local function update_battery()
  sbar.exec("pmset -g batt", function(info)
    local percentage = tonumber((info or ""):match("(%d+)%%"))
    if not percentage then
      battery:set({ drawing = false })
      return
    end

    -- AC power also covers a full battery and charging paused by macOS.
    local state = helpers.trim((info or ""):match("%d+%%;%s*([^;]+)") or "")
    local charging = state == "charging"
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

local volume = sbar.add("item", "status.volume", {
  position = "right",
  update_freq = 30,
  icon = {
    string = icons.volume.medium,
    color = colors.nord7,
  },
  label = {
    string = "--",
    width = "dynamic",
    align = "left",
    color = colors.text_muted,
  },
})

local function set_volume(info, code)
  local level = tonumber((info or ""):match("output volume:%s*(%d+)"))
  local muted = (info or ""):match("output muted:%s*(%a+)")
  if code ~= 0 or not level or not muted then
    volume:set({ label = { string = "--" } })
    return
  end
  local icon = icons.volume.muted
  if muted == "true" then
    icon = icons.volume.muted
  elseif level >= 60 then
    icon = icons.volume.high
  elseif level >= 30 then
    icon = icons.volume.medium
  elseif level > 0 then
    icon = icons.volume.low
  end

  volume:set({
    icon = { string = icon },
    label = { string = muted == "true" and "Muted" or tostring(level) .. "%" },
  })
end

local function update_volume()
  sbar.exec("/usr/bin/osascript -e 'get volume settings'", set_volume)
end
volume:subscribe({ "volume_change", "routine", "forced", "system_woke" }, update_volume)
volume:subscribe("mouse.clicked", function()
  sbar.exec("/usr/bin/osascript -e 'set volume output muted not (output muted of (get volume settings))'", update_volume)
end)

local network = sbar.add("item", "status.network", {
  position = "right",
  update_freq = 60,
  icon = {
    string = icons.wifi.connected,
    color = colors.nord9,
  },
  label = { string = "Wi-Fi", drawing = true },
})

local function update_network()
  local function show_network(label, connected)
    network:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and colors.nord9 or colors.nord11,
      },
      label = { string = label },
    })
  end

  sbar.exec("/usr/sbin/networksetup -listallhardwareports", function(ports, code)
    if code ~= 0 then
      show_network("Wi-Fi ?", false)
      return
    end
    local device
    for port, name in (ports or ""):gmatch("Hardware Port: ([^\n]+)\nDevice: ([^\n]+)") do
      if helpers.trim(port) == "Wi-Fi" or helpers.trim(port) == "AirPort" then
        device = helpers.trim(name)
        break
      end
    end
    -- Validate before including the discovered interface in a shell command.
    if not device or not device:match("^en%d+$") then
      show_network("No Wi-Fi", false)
      return
    end
    sbar.exec("/usr/sbin/networksetup -getairportpower " .. device
      .. " && /sbin/ifconfig " .. device, function(info, exit_code)
      local power = (info or ""):match("Wi%-Fi Power %([^)]*%):%s*(%a+)")
        or (info or ""):match("AirPort Power %([^)]*%):%s*(%a+)")
      if exit_code ~= 0 or not power then
        show_network("Wi-Fi ?", false)
      elseif power == "Off" then
        show_network("Wi-Fi off", false)
      else
        -- Link state works before DHCP completes and on IPv6-only networks.
        local connected = (info or ""):match("status:%s*(%a+)") == "active"
        show_network(connected and "Wi-Fi" or "Wi-Fi disconnected", connected)
      end
    end)
  end)
end

update_clock()
update_battery()
update_volume()
update_network()

network:subscribe({ "routine", "wifi_change", "system_woke", "forced" }, update_network)
network:subscribe("mouse.clicked", function()
  sbar.exec("open 'x-apple.systempreferences:com.apple.wifi-settings-extension'")
end)

-- Use the same spacing and baseline for each status icon/value pair.
for _, item in ipairs({ network, volume, battery }) do
  item:set({
    padding_left = 3,
    padding_right = 3,
    icon = {
      font = { family = settings.font, style = "Regular", size = 12.0 },
      y_offset = 0,
      padding_left = 3,
      padding_right = 2,
      width = "dynamic",
    },
    label = {
      font = { family = settings.label_font, style = "Medium", size = 11.0 },
      y_offset = 0,
      padding_left = 2,
      padding_right = 3,
      width = "dynamic",
      align = "left",
    },
  })
end
