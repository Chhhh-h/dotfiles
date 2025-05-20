local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 40,
  color = colors.transparent,
  padding_right = 15,
  padding_left = 15,
  sticky = on,
  topmost = on,
})
