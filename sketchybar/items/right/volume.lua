local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- 工具函数：小于10前补0
local function with_leading_zero(n)
  return (n < 10 and "0" or "") .. n
end

-- 音量图标选择逻辑
local function get_volume_icon(percent)
  if percent > 60 then return icons.volume._100
  elseif percent > 30 then return icons.volume._66
  elseif percent > 10 then return icons.volume._33
  elseif percent > 0 then return icons.volume._10
  else return icons.volume._0 end
end

-- 添加 volume item
local volume = sbar.add("item", "volume", {
  label = { width = 0, padding_left = 0 },
  position = "right",
  click_script = "open /System/Library/PreferencePanes/Sound.prefpane",
  background = { color = colors.transparent, border_width = 0 }
})

-- 音量更新逻辑
volume:subscribe({ "volume_change", "system_woke" }, function(env)
  local percent = tonumber(env.INFO)
  local icon = get_volume_icon(percent)
  volume:set({
    icon = { string = icon },
    label = { string = with_leading_zero(percent) .. "%" },
  })

  sbar.animate("tanh", 20, function()
    volume:set({ label = { width = "dynamic" } })
  end)
  sbar.delay(2, function()
    sbar.animate("tanh", 20, function()
      volume:set({ label = { width = 0 } })
    end)
  end)

end)

volume:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    volume:set({
      label = { width = "dynamic" },
    })
  end)
end)

volume:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    volume:set({
      label = { width = 0 },
    })
  end)
end)

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