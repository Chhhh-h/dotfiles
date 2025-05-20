local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local menubar = sbar.add("item", "menubar", {
  icon = {
    string = icons.menu,
    style = settings.font.style_map["ExtraBold"],
  },
  label = { drawing = false },
  background = {height = 25, color = colors.transparent, border_width = 0 }
})

menubar:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    menubar:set({
      background = {
        color = colors.orange,
      },
      icon = { color = colors.black },
    })
  end)
end)

menubar:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    menubar:set({
      background = {
        color = colors.transparent, 
      },
      icon = { color = colors.white },
    })
  end)
end)

menubar:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

sbar.add("item", {
  position = "left",
  width = settings.group_paddings,
  background = {color = colors.transparent, border_width = 0 }
})

local spaces = {}
for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      string = i,
    },
    label = {
      font = "sketchybar-app-font:Regular:16.0"
    },
    padding_right = 5,
    background = { 
      height = 2, 
      color = colors.transparent, 
      border_width = 0,
      y_offset = -10,
    }
  })
  spaces[i] = space

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    sbar.animate("tanh", 20, function()
      space:set({
        icon = { 
          color = selected and colors.yellow or colors.white, 
        },
        label = {
          width = selected and 0 or "dynamic",  -- 宽度为 0 表示隐藏
        },
        background = {color = selected and colors.yellow or colors.transparent },
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

menubar:subscribe("space_windows_change", function(env)
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


local spaces_indicator = sbar.add("item", "spaces_indicator", {
  icon = {
    string = icons.switch.on,
    style = settings.font.style_map["ExtraBold"],
    padding_left = 0,
    padding_right = 10,
  },
  label = { drawing = false },
  background = {color = colors.transparent, border_width = 0 }
})