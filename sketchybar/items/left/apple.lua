local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local left_padding = sbar.add("item", "left_padding", {
  position = "left",
  width = settings.group_paddings,
  background = {color = colors.transparent, border_width = 0 }
})

local apple = sbar.add("item", "apple", {
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    image = {
      string = "~/.config/sketchybar/pics/pokeball.png",
    },
    color = colors.transparent,
    border_width = 0
  },
  click_script = "open -a 'System Settings'"
})

apple:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    apple:set({
      background = {
        image = {
          string = "~/.config/sketchybar/pics/pokeballopen.png",
        },
      },
    })
  end)
end)

apple:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    apple:set({
      background = {
        image = {
          string = "/Users/caizhihao/.config/sketchybar/pics/pokeball.png",
        },
      },
    })
  end)
end)

sbar.add("item", { position = "left", width = settings.group_paddings, background = { color = colors.transparent, border_width = 0 }})