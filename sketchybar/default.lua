local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 16.0
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    background = { 
      image = { corner_radius = 10 },
      color = colors.transparent },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Medium"],
      size = 16.0
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    background = { color = colors.transparent }
  },
  background = {
    height = 30,
    corner_radius = 10,
    color = colors.bg1,
    blur_radius = 50,
    border_width = 2,
    border_color = colors.lavender,
    image = {
      corner_radius = 10,
--      border_color = colors.grey,
--      border_width = 1
    },
  },
  popup = {
    background = {
      border_width = 2,
      corner_radius = 10,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 50,
  },
  scroll_texts = true,
})
