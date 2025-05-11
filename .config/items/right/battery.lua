local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", {
  position = "right",
  update_freq = 180,
  popup = { align = "center" },
  click_script = "open -a 'Clash Verge'",
  background = {color = colors.transparent, border_width = 0 }
})

local battery_bracket = sbar.add("bracket", "battery.bracket", {
  battery.name,
}, {
  popup = { align = "center" }
})


battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = colors.green
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = icons.battery.charging
      if charge > 60 then
        color = colors.green
      elseif charge > 40 then
        color = colors.yellow
      elseif charge > 20 then
        color = colors.orange
      else
        color = colors.red
      end
    else
      if found and charge > 80 then
        icon = icons.battery._100
        color = colors.green
      elseif found and charge >= 60 then
        icon = icons.battery._75
        color = colors.green
      elseif found and charge >= 40 then
        icon = icons.battery._50
        color = colors.yellow
      elseif found and charge >= 20 then
        icon = icons.battery._25
        color = colors.orange
      else
        icon = icons.battery._0
        color = colors.red
      end
    end

    local lead = ""
    if found and charge < 10 then
      lead = "0"
    end

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = { string = lead .. label },
    })
  end)
end)

--battery:subscribe("mouse.entered", function(env)
--  sbar.animate("tanh", 20, function()
--    battery_bracket:set({
--      background = {
--        color = colors.orange,
--      }
--    })
--    battery:set({
--      label = { color = colors.black }
--    })
--  end)
--end)
--
--battery:subscribe("mouse.exited", function(env)
--  sbar.animate("tanh", 20, function()
--    battery_bracket:set({
--      background = {
--        color = colors.bg1,
--      }
--    })
--    battery:set({
--      label = { color = colors.white }
--    })
--  end)
--end)


sbar.add("item", {
  position = "right",
  width = settings.group_paddings,
  background = {color = colors.transparent, border_width = 0 }
})
