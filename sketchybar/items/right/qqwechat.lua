local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local wechat = sbar.add("item", "wechat", {
  position = "right",
  icon = { 
    font = "sketchybar-app-font:Regular:16.0",
    string = app_icons["微信"],
    padding_left = 0,
    padding_right = 0
  },
  label = { padding_left = 5 },
  update_freq = 5,
  click_script = "open -a 'WeChat'",
  background = { color = colors.transparent, border_width = 0 }
})

local qq = sbar.add("item", "qq", {
  position = "right",
  icon = { 
    font = "sketchybar-app-font:Regular:16.0",
    string = app_icons["QQ"],
    padding_right = 0,
  },
  label = { padding_left = 5 },
  update_freq = 5,
  click_script = "open -a 'QQ'",
  background = { color = colors.transparent, border_width = 0 }
})

-- 通用订阅更新函数
local function subscribe_app_label(item, app_keyword)
  item:subscribe({ "forced", "routine" }, function()
    local script = string.format([[
      lsappinfo -all list | grep %s | 
      egrep -o "\"StatusLabel\"=\{ \"label\"=\"?(.*?)\"? \}" | 
      sed 's/.*label\"=\"\(.*\)\".*/\1/g'
    ]], app_keyword)

    sbar.exec(script, function(output)
      local message = output:match("%S+") or "0"
      item:set({ label = { string = message } })
    end)
  end)
end

-- 启动状态更新订阅
subscribe_app_label(wechat, "WeChat")
subscribe_app_label(qq, "QQ")

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