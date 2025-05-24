local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

-- 工具函数：根据天气条件返回图标
local function get_weather_icon(condition)
  local cond = condition:lower()
  if cond:find("sun") or cond:find("clear") then return icons.weather.sunny end
  if cond:find("cloud") or cond:find("overcast") then return icons.weather.cloudy end
  if cond:find("rain") or cond:find("shower") then return icons.weather.rainy end
  if cond:find("thunder") then return icons.weather.thunder end
  if cond:find("snow") or cond:find("sleet") then return icons.weather.snow end
  if cond:find("mist") or cond:find("fog") then return icons.weather.fog end
  return icons.weather.sunny
end


local weather = sbar.add("item", "weather", {
  icon = {
    string = icons.weather.sunny, 
    padding_right = 0,
  },
  label = { 
    string = "--°C",
    font = { 
      style = settings.font.style_map["Bold"],
    },
    width = 50,
    padding_left = 5,
  },
  position = "right",
  update_freq = 180,
  click_script = "open -a 'Weather'",
  background = {color = colors.transparent, border_width = 0 }
})

-- 执行天气数据请求
weather:subscribe({ "forced", "routine", "system_woke" }, function(env)
  sbar.exec([[
    bash -c '
      city=$(curl -s "wttr.in/?format=j1" | jq -r ".nearest_area[0].areaName[0].value")
      weather=$(curl -s "wttr.in/?format=%C+%t")
      moon=$(curl -s "wttr.in/?format=j1" | jq -r ".weather[0].astronomy[0].moon_phase")
      echo "$city"
      echo "$weather"
      echo "$moon"
    '
  ]], function(output)
    local lines = {}
    for line in output:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end

    local city = lines[1] or "Unknown"
    local weather_str = lines[2] or ""
    local moon_phase = (lines[3] or ""):lower():gsub("%s", "")
    local moon_icon = icons.moon[moon_phase] or icons.moon.fullmoon

    -- 解析天气和温度
    local condition, temp = string.match(weather_str, "([^%+]+)%s*%+?(-?%d+°[CF]?)")
    condition = condition and condition:match("^%s*(.-)%s*$") or ""
    temp = temp and temp:gsub("^%+", "") or "N/A"

    weather:set({
      icon = { string = get_weather_icon(condition) },
      label = { string = temp .. " " .. city .. moon_icon }
    })
  end)
end)

weather:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    weather:set({
      label = { width = "dynamic" }
    })
  end)
end)

weather:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    weather:set({
      label = { width = 50 }
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