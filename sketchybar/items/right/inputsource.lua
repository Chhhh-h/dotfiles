local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- 添加WIFI
local inputsource = sbar.add("item", "inputsource", {
  position = "right",
  icon = { padding_left = 0 },
  label = { width = 0, padding_left = 0 },
  click_script="osascript -e 'tell application \"System Events\" to keystroke \" \" using {control down, option down}'",
  background = {color = colors.transparent, border_width = 0 }
})


wifi:subscribe({ "forced", "system_woke" }, function(env)
  sbar.exec([[
    bash -c '
      ip=$(ipconfig getifaddr en0)
      ssid=$(ipconfig getsummary en0 | awk -F " SSID : " "/ SSID : / {print \$2}")
      echo "$ip"
      echo "$ssid"
    '
  ]], function(output)
    local lines = {}
    for line in output:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end

    local ip = lines[1] or ""
    local ssid = lines[2] or ""
    local connected = ip ~= ""

    wifi:set({
      icon = {
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and colors.white or colors.red,
      },
      label = { string = ssid }
    })

    sbar.animate("tanh", 20, function()
      wifi:set({ label = { width = "dynamic" } })
    end)
    sbar.delay(2, function()
      sbar.animate("tanh", 20, function()
        wifi:set({ label = { width = 0 } })
      end)
    end)

  end)
end)

wifi:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    wifi:set({
      label = { width = "dynamic" },
    })
  end)
end)

wifi:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    wifi:set({
      label = { width = 0 },
    })
  end)
end)