local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu" , 42, {
  position = "right",
  graph = { color = colors.green },
  icon = { string = icons.cpu },
  label = {
    string = "00%",
    font = {
      size = 14.0,
    },
    align = "right",
    width = 5,
    y_offset = 4
  },
})

cpu:subscribe("cpu_update", function(env)
  -- Also available: env.user_load, env.sys_load
  local load = tonumber(env.total_load)
  cpu:push({ load / 100. })

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

  cpu:set({
    graph = { color = color },
    label = { 
      string = env.total_load .. "%",
      color = color
    }
  })
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

