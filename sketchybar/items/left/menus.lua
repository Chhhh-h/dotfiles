local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local menu_watcher = sbar.add("item", {
  drawing = false,
  updates = false,
})
local space_menu_swap = sbar.add("item", {
  drawing = false,
  updates = true,
})
sbar.add("event", "swap_menus_and_spaces")

local max_items = 15
local menu_items = {}
for i = 1, max_items, 1 do
  local menu = sbar.add("item", "menu." .. i, {
    drawing = false,
    icon = { drawing = false },
    label = {
      font = {
        style = settings.font.style_map[i == 1 and "ExtraBold" or "Semibold"],
      },
      padding_left = 5,
      padding_right = 5,
    }, 
    background = { 
      height = 2, 
      color = colors.transparent, 
      border_width = 0,
      y_offset = -10,
    },
    click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s " .. i,
  })

  menu_items[i] = menu 

  menu:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 10, function()
      menu:set({
        label = { color = colors.yellow },
        background = { color = colors.yellow },
      })
    end)
  end)
  menu:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 10, function()
      menu:set({
        label = { color = colors.white },
        background = { color = colors.transparent },
      })
    end)
  end)
end

-- sbar.add("bracket", { '/menu\\..*/' }, {
-- })

sbar.add("bracket", { 
  "left_padding", "apple", "front_app", "spaces_indicator", 
  "menubar", '/space\\..*/' , '/menu\\..*/',
}, {
})


local function update_menus(env)
  sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(menus)
    sbar.set('/menu\\..*/', { drawing = false })
    id = 1
    for menu in string.gmatch(menus, '[^\r\n]+') do
      if id < max_items then
        menu_items[id]:set( { label = menu, drawing = true } )
      else break end
      id = id + 1
    end
  end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

space_menu_swap:subscribe("swap_menus_and_spaces", function(env)
  local drawing = menu_items[1]:query().geometry.drawing == "on"
  if drawing then
    menu_watcher:set( { updates = false })
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("/space\\..*/", { drawing = true })
    sbar.set("front_app", { label = { drawing = true } })
    sbar.set("spaces_indicator", { drawing = true })
  else
    menu_watcher:set( { updates = true })
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("front_app", { label = { drawing = false } })
    sbar.set("spaces_indicator", { drawing = false })
    update_menus()
  end
end)

return menu_watcher
