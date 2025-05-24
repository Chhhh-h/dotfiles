local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- 工具函数：小于10前补0
local function with_leading_zero(n)
  return (n < 10 and "0" or "") .. n
end

-- 电池图标和颜色选择逻辑
local function get_battery_icon_and_color(charge, charging)
  if charging then
    if charge >= 60 then return icons.battery.charging, colors.green
    elseif charge >= 40 then return icons.battery.charging, colors.yellow
    elseif charge >= 20 then return icons.battery.charging, colors.orange
    else return icons.battery.charging, colors.red end
  else
    if charge > 80 then return icons.battery._100, colors.green
    elseif charge >= 60 then return icons.battery._75, colors.green
    elseif charge >= 40 then return icons.battery._50, colors.yellow
    elseif charge >= 20 then return icons.battery._25, colors.orange
    else return icons.battery._0, colors.red end
  end
end

-- 添加 battery item
local battery = sbar.add("item", "battery", {
  icon = { padding_left = 0 },
  label = { width = 0, padding_left = 0 },
  position = "right",
  update_freq = 180,
  click_script = "open -a 'AlDente'",
  background = { color = colors.transparent, border_width = 0 }
})

-- 电量更新逻辑
battery:subscribe({"routine", "power_source_change", "system_woke" }, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local _, _, charge_str = batt_info:find("(%d+)%%")
    local charge = tonumber(charge_str or "0")
    local charging = batt_info:find("AC Power") ~= nil

    local icon, color = get_battery_icon_and_color(charge, charging)
    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = { string = with_leading_zero(charge) .. "%" },
    })

    sbar.animate("tanh", 20, function()
      battery:set({ label = { width = "dynamic" } })
    end)
    sbar.delay(2, function()
      sbar.animate("tanh", 20, function()
        battery:set({ label = { width = 0 } })
      end)
    end)

  end)
end)

battery:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    battery:set({
      label = { width = "dynamic" },
    })
  end)
end)

battery:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    battery:set({
      label = { width = 0 },
    })
  end)
end)

