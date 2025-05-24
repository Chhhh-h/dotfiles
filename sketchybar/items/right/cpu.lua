local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

cpu = sbar.add("graph", "cpu" , 80, {
  position = "right",
  graph = { color = colors.green },
  icon = { 
    string = icons.cpu,
    padding_right = 0,
  },
  label = {
    string = "00%",
    font = {
      size = 16.0,
    },
    align = "right",
    width = 5,
    y_offset = 2
  },
  click_script = "open -a 'Activity Monitor'",
  background = {color = colors.transparent, border_width = 0 }
})

local right_bracket = sbar.add("bracket", "right.bracket", {
  "cal", "holiday", "weather", "wifi", "battery", "volume", "qq", "wechat", "cpu",
}, {
  background = {
    height = 30,
    corner_radius = 10,
    color = colors.bg1,
    blur_radius = 50,
    y_offset = 0
  }
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

-- cpu_bracket:subscribe("mouse.entered", function(env)
--   sbar.animate("tanh", 20, function()
--     cpu_bracket:set({
--       background = {
--         color = colors.orange,
--       }
--     })
--     cpu:set({
--       icon = { color = colors.black },
--     })
--   end)
-- end)

-- cpu_bracket:subscribe("mouse.exited", function(env)
--   sbar.animate("tanh", 20, function()
--     cpu_bracket:set({
--       background = {
--         color = colors.bg1,
--       }
--     })
--     cpu:set({
--       background = {
--         color = colors.transparent ,
--       },
--       icon = { color = colors.white },
--     })
--   end)
-- end)

-- sbar.add("item", {
--   position = "right",
--   width = settings.group_paddings,
--   background = {color = colors.transparent, border_width = 0 }
-- })

