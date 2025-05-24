local icons = require("icons")
local colors = require("colors")
local app_icons = require("helpers.app_icons")

local mail = sbar.add("item", "mail", {
  position = "right",
  icon = { 
    font = "sketchybar-app-font:Regular:16.0",
    string = app_icons["Mail"],
    padding_right = 0,
  },
  label = { string = 0, padding_left = 5 },
  update_freq = 5,
  click_script = "open -a 'Mail'",
  background = { color = colors.transparent, border_width = 0 }
})

mail:subscribe({ "forced", "routine", "system_woke" }, function()
  sbar.exec("osascript ~/.config/sketchybar/scripts/emails.applescript", function(output)
    local count = tonumber(output) or 0
    mail:set({
      label = { string = tostring(count) }
    })
  end)
end)