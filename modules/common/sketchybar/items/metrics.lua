local colors = require("colors")
local settings = require("settings")

local function metric(name, title, frequency)
  local item = sbar.add("item", "metrics." .. name, {
    position = "right",
    update_freq = frequency,
    padding_left = 3,
    padding_right = 3,
    icon = {
      string = title,
      color = colors.nord9,
      font = { family = settings.label_font, style = "Semibold", size = 11.0 },
      y_offset = settings.label_y_offset,
    },
    label = { string = "--", width = "dynamic", align = "left", color = colors.text_muted },
  })
  item:subscribe("mouse.clicked", function()
    sbar.exec("/usr/bin/open -a 'Activity Monitor'")
  end)
  return item
end

-- Right-side items are created from right to left: NET, RAM, CPU.
-- Fit the current text: a fixed width leaves a hole on either side of the rates.
local network = metric("network", "NET", 3)
local previous, previous_time
local network_pending = false
local function rate(bytes)
  if bytes >= 1024 * 1024 then return string.format("%.1f MB/s", bytes / (1024 * 1024)) end
  return string.format("%.0f KB/s", bytes / 1024)
end

local function update_network(env)
  if env and env.SENDER == "system_woke" then
    previous, previous_time = nil, nil
  end
  if network_pending then return end
  network_pending = true
  -- One link-layer row per physical interface; omit loopback and VPN duplicates.
  sbar.exec("LC_ALL=C /usr/sbin/netstat -ibn", function(output, code)
    network_pending = false
    local now, current = os.time(), {}
    if code == 0 then
      for line in (output or ""):gmatch("[^\n]+") do
        local fields = {}
        for field in line:gmatch("%S+") do fields[#fields + 1] = field end
        if fields[1] and fields[1]:match("^en%d+$") and (fields[3] or ""):match("^<Link#") then
          local received, sent = tonumber(fields[7]), tonumber(fields[10])
          if received and sent then current[fields[1]] = { received, sent } end
        end
      end
    end
    local elapsed = previous_time and now - previous_time
    local down, up = 0, 0
    -- Restart the baseline after failures, sleep, or missed samples.
    if previous and elapsed and elapsed > 0 and elapsed <= 15 then
      for name, counters in pairs(current) do
        local old = previous[name]
        if old and counters[1] >= old[1] and counters[2] >= old[2] then
          down = down + (counters[1] - old[1]) / elapsed
          up = up + (counters[2] - old[2]) / elapsed
        end
      end
    end
    previous, previous_time = current, now
    network:set({
      label = { string = code == 0 and next(current) ~= nil
        and ("↓ " .. rate(down) .. "  ↑ " .. rate(up)) or "Unavailable" },
    })
  end)
end
network:subscribe({ "routine", "forced", "system_woke" }, update_network)

local memory = metric("memory", "RAM", 10)
local function update_memory()
  sbar.exec("/usr/sbin/sysctl -n kern.memorystatus_vm_pressure_level hw.memsize && /usr/bin/vm_stat", function(output, code)
    -- sysctl exposes NOTE_MEMORYSTATUS_PRESSURE_* flags, not a RAM percentage.
    local palette = { [1] = colors.nord14, [2] = colors.nord13, [4] = colors.nord11 }
    local pressure, total, stats = (output or ""):match("^(%d+)%s+(%d+)%s+(.*)")
    local color = code == 0 and palette[tonumber(pressure)]
    local value = "--"
    if code == 0 and stats then
      local page_size = tonumber(stats:match("page size of (%d+) bytes"))
      local pages = {}
      for name, count in stats:gmatch("([^\n:]+):%s+(%d+)") do pages[name] = tonumber(count) end
      local anonymous, wired, compressed = pages["Anonymous pages"], pages["Pages wired down"], pages["Pages occupied by compressor"]
      if page_size and anonymous and wired and compressed and tonumber(total) > 0 then
        -- Resident anonymous, wired, and compressed pages; excludes file cache.
        local used = math.min(tonumber(total), (anonymous + wired + compressed) * page_size)
        value = string.format("%.1f/%.0f GB", used / 2^30, tonumber(total) / 2^30)
      end
    end
    memory:set({ label = {
      string = value,
      color = color or colors.text_muted,
    } })
  end)
end
memory:subscribe({ "routine", "forced", "system_woke" }, update_memory)

local cpu = metric("cpu", "CPU", 5)
local cpu_pending = false
local function update_cpu()
  if cpu_pending then return end
  cpu_pending = true
  -- Discard top's first (since-boot) sample. Disable expensive process scans.
  sbar.exec("LC_ALL=C /usr/bin/top -l 2 -s 1 -n 0 -R -F", function(output, code)
    cpu_pending = false
    local idle
    if code == 0 then
      for value in (output or ""):gmatch("([%d.]+)%% idle") do
        idle = tonumber(value)
      end
    end
    local usage = idle and math.max(0, math.min(100, 100 - idle))
    cpu:set({ label = { string = usage and string.format("%.0f%%", usage) or "--" } })
  end)
end
cpu:subscribe({ "routine", "forced", "system_woke" }, update_cpu)


update_cpu()
update_memory()
update_network()
