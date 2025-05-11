local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", {
  icon = {
    font = {
      size = 16.0 
    },
    padding_right = 0
  },
  position = "right",
  update_freq = 30,
  click_script = "open -a 'Calendar'",
  background = {color = colors.transparent, border_width = 0 }
})

local cal_bracket = sbar.add("bracket", "cal.bracket", {
  cal.name,
}, {
  popup = { align = "center" }
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a %b.%d"), label = os.date("%H:%M") })
end)

cal:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    cal_bracket:set({
      background = {
        color = colors.orange,
      }
    })
    cal:set({
      icon = { color = colors.black },
      label = { color = colors.black }
    })
  end)
end)

cal:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    cal_bracket:set({
      background = {
        color = colors.bg1,
      }
    })
    cal:set({
      background = {
        color = colors.transparent ,
      },
      icon = { color = colors.white },
      label = { color = colors.white }
    })
  end)
end)

sbar.add("item", { position = "right", width = settings.group_paddings, background = { color = colors.transparent, border_width = 0 }})