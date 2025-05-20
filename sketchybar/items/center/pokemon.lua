local colors = require("colors")

sbar.add("item", { 
  position = "center", 
  width = 280, 
  background = { color = colors.transparent, border_width = 0 
  }
})

local mew = sbar.add("item", {
  position = "center",
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    image = {
      string = "~/.config/sketchybar/pics/mew.png",
      scale = 0.12,
    },
    color = colors.transparent,
    border_width = 0
  },
})

local celebi = sbar.add("item", {
  position = "center",
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    image = {
      string = "~/.config/sketchybar/pics/celebi.png",
      scale = 0.12,
    },
    color = colors.transparent,
    border_width = 0
  },
})

local jirachi = sbar.add("item", {
  position = "center",
  icon = { drawing = false },
  label = { drawing = false },
  background = {
    image = {
      string = "~/.config/sketchybar/pics/jirachi.png",
      scale = 0.12,
    },
    color = colors.transparent,
    border_width = 0
  },
})
