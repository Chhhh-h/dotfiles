local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      string = i,
      padding_left = 10,
      padding_right = 10,
      highlight_color = colors.black,
    },
    label = {
      padding_right = 10,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0"
    },
    padding_right = 5
  })

  spaces[i] = space
  
local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_width = 0 
    }
  })

space:subscribe("space_change", function(env)
  local selected = env.SELECTED == "true"
  sbar.animate("tanh", 20, function()
    space:set({
    icon = { highlight = selected },
    label = {
      highlight = selected,
      width = selected and 0 or "dynamic",  -- 宽度为 0 表示隐藏
    },
    background = {color = selected and colors.yellow or colors.bg1 },
  })
  end)
end)
 
space:subscribe("mouse.clicked", function(env)
   if env.BUTTON == "other" then
     space_popup:set({ background = { image = "space." .. env.SID } })
     space:set({ popup = { drawing = "toggle" } })
   else
     local op = (env.BUTTON == "right") and "--destroy" or "--focus"
     sbar.exec("yabai -m space " .. op .. " " .. env.SID)
   end
end)

end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  for app, count in pairs(env.INFO.apps) do
    no_app = false
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["Default"] or lookup)
    icon_line = icon_line .. icon
  end

  if (no_app) then
    icon_line = " —"
  end
  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = icon_line })
  end)
end)



local spaces_indicator = sbar.add("item", {
  icon = {
    string = icons.switch.on,
    style = settings.font.style_map["ExtraBold"],
  },
  label = {
    width = 8,
    string = "switch",
  },
  padding_left = 0,
  padding_right = 5,
  background = {color = colors.transparent, border_width = 0 }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    spaces_indicator:set({
      background = {
        color = colors.orange,
      },
      icon = { color = colors.black },
      label = { width = "dynamic",
                color = colors.black }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    spaces_indicator:set({
      background = {
        color = colors.transparent ,
      },
      icon = { color = colors.white },
      label = { width = 8,
                color = colors.white }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
