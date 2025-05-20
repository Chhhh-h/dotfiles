local colors = require("colors")
local settings = require("settings")

-- Events that get pushed by yabai
sbar.add("event", "window_focus")
sbar.add("event", "title_change")

local front_app = sbar.add("item", "front_app", { 
  display = "active",
  icon = { 
    font = "sketchybar-app-font:Regular:16.0" ,
  },
  label = {
    font = {
      style = settings.font.style_map["Bold"],
    },
    padding_right = 10,
  },
  background = {color = colors.transparent, border_width = 0}
})

local function end_bounce_animation()
  sbar.animate("tanh", 20, function()
    front_app:set({
      icon = {
        background = {
          image = { scale = 1.0 },
        }
      }
    })
  end)
end

local function start_bounce_animation()
  sbar.animate("tanh", 20, function()
    front_app:set({
      icon = {
        background = {
          image = { scale = 1.5 },
	}
      }
    })
  end)
  sbar.exec("sleep 0.25 && echo 'finishing bounce'", end_bounce_animation) 
end

front_app:subscribe("space_change", function()
  start_bounce_animation()
end)

front_app:subscribe("window_focus", function()
  start_bounce_animation()
end)

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    icon = { background = { image = "app." .. env.INFO }},
    label = { string = env.INFO } 
  })
  start_bounce_animation()
end)

sbar.add("item", { position = "left", width = settings.group_paddings, background = { color = colors.transparent, border_width = 0  }})