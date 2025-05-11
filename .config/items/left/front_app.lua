local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Events that get pushed by yabai
sbar.add("event", "window_focus")
sbar.add("event", "title_change")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { 
    padding_left = 10,
    font = "sketchybar-app-font:Regular:16.0" 
  },
  label = {
    padding_right = 10,
    font = {
      style = settings.font.style_map["Bold"],
      size = 16.0,
    },
  },
  background = {color = colors.transparent, border_width = 0}
})

local front_app_bracket = sbar.add("bracket", "front_app.bracket", {
  front_app.name,
}, {
  background = {border_color = colors.magenta},
  popup = { align = "center" }
})


local function end_bounce_animation()
  sbar.animate("tanh", 15, function()
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
  sbar.animate("tanh", 15, function()
    front_app:set({
      icon = {
        background = {
          image = { scale = 1.2 },
	}
      }
    })
  end)
  sbar.exec("sleep 0.25 && echo 'finishing bounce'", end_bounce_animation) 
end

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    icon = { background = { image = "app." .. env.INFO } }
  })
  start_bounce_animation()
end)

front_app:subscribe("space_change", function()
  start_bounce_animation()
end)

front_app:subscribe("window_focus", function()
  start_bounce_animation()
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    icon = { background = { image = "app." .. env.INFO }},
    label = { string = env.INFO } 
  })
  start_bounce_animation()
end)

front_app:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    front_app:set({
      background = {
        color = colors.yellow,
      },
      icon = { color = colors.black },
      label = { color = colors.black }
    })
  end)
end)

front_app:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    front_app:set({
      background = {
        color = colors.transparent ,
      },
      icon = { color = colors.white },
      label = { color = colors.white }
    })
  end)
end)

sbar.add("item", { position = "left", width = settings.group_paddings, background = { color = colors.transparent, border_width = 0  }})