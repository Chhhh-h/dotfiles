local settings = require("settings")
local colors = require("colors")

local holiday = sbar.add("item", "holiday",{
 icon = {
   font = {
     size = 12.0 ,
   },
 },
 label = { drawing = false },
 position = "right",
 width = 0,
 y_offset = -7,
 click_script = "open -a 'Calendar'",
 background = {color = colors.transparent, border_width = 0 }
})

local cal = sbar.add("item", "cal",{
  icon = {
    padding_right = 0
  },
  label = { padding_right = 10},
  position = "right",
  update_freq = 15,
  click_script = "open -a 'Calendar'",
  background = {color = colors.transparent, border_width = 0 }
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a %b.%d"), label = os.date("%H:%M") })
  sbar.exec("~/miniconda3/bin/python3 ~/.config/sketchybar/scripts/holiday.py", function(output)
    if output and output ~= "" then
      holiday:set({ icon = output })
      cal:set({ 
        icon = { y_offset = 5 },
        label = { y_offset = 5 } 
      })
    else
      holiday:set({ icon = {drawing = off} })
      cal:set({ 
        icon = { y_offset = 0 },
        label = { y_offset = 0 } 
      })
    end
  end)
end)

-- cal:subscribe("mouse.entered", function(env)
--   sbar.animate("tanh", 10, function()
--     cal:set({
--       background = { y_offset = -10 }
--     })
--   end)
-- end)

-- cal:subscribe("mouse.exited", function(env)
--   sbar.animate("tanh", 10, function()
--     cal:set({
--       background = { y_offset = -30 }
--     })
--   end)
-- end)

sbar.add("item", { 
  icon = {
    string = "|",
    color = colors.with_alpha(colors.white, 0.6)
  },
  label = {drawing = false},
  
  position = "right", 
  width = settings.group_paddings, 
  background = { color = colors.transparent, border_width = 0 }
})