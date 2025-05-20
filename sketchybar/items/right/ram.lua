local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("graph", "ram", 50, {
  position = "right",
  graph = { color = colors.green },
  icon = { string = icons.ram },
  label = {
    string = "00%",
    font = {
      size = 14.0,
    },
    align = "right",
    width = 5,
    y_offset = 4
  },
  update_freq = 1,
  background = { color = colors.transparent, border_width = 0 }
})

local ram_bracket = sbar.add("bracket", "ram.bracket", {
  ram.name,
}, {
  background = { border_color = colors.red },
  popup = { align = "center" }
})

-- 每次 routine（系统定时）更新
ram:subscribe("routine", function()
  sbar.exec([[memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", $5) }']], function(output)
    local load = tonumber(output)
    if not load then return end

    ram:push({ load / 100. })

    local color = colors.green
    if load > 30 then
      if load < 60 then
        color = colors.yellow
      elseif load < 80 then
        color = colors.orange
      else
        color = colors.red
      end
    end

    ram:set({
      graph = { color = color },
      label = {
        string = load .. "%",
        color = color
      }
    })
  end)
end)