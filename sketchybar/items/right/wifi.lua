local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- 工具函数：显示 label 后延迟隐藏
local function show_label_temporarily(item, label_text)
  sbar.animate("tanh", 20, function()
    item:set({ label = { string = label_text, width = "dynamic" } })
  end)
  sbar.delay(2, function()
    sbar.animate("tanh", 20, function()
      item:set({ label = { width = 0 } })
    end)
  end)
end

-- 添加WIFI
local wifi = sbar.add("item", "wifi", {
  position = "right",
  icon = { padding_left = 0 },
  label = { width = 0, padding_left = 0 },
  click_script = "open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi'",
  background = {color = colors.transparent, border_width = 0 }
})


wifi:subscribe({ "wifi_change", "system_woke" }, function(env)
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
      }
    })

    show_label_temporarily(wifi, ssid)
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