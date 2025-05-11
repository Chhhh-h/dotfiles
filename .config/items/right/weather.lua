local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

local location = sbar.add("item", {
  position = "right",
  width = 0,
  icon = { drawing = off },
  label = {
    font = {
      size = 10.0,
    },
    padding_left = 5,
    string = "Location",
  },
  y_offset = 7,
  click_script = "open -a 'Weather'",
  background = {color = colors.transparent, border_width = 0 }
})

local weather = sbar.add("item", {
  icon = {
    string = icons.weather.sunny, 
    padding_right = 0,
  },
  label = { 
    string = "N/A",
    font = { 
      style = settings.font.style_map["Bold"],
      size = 14.0 },
    y_offset = -5
  },
  position = "right",
  updates = true,
  update_freq = 300,
  background = {color = colors.transparent, border_width = 0 }
})

local weather_bracket = sbar.add("bracket", "weather.bracket", {
  location.name,
  weather.name,
}, {
  popup = { align = "center", height = 30 }
})

weather:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    weather_bracket:set({
      background = {
        color = colors.orange,
      }
    })
    weather:set({
      icon = { color = colors.black },
      label = { color = colors.black }
    })
    location:set({
      label = { color = colors.black }
    })
  end)
end)

weather:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    weather_bracket:set({
      background = {
        color = colors.bg1,
      }
    })
    weather:set({
      icon = { color = colors.white },
      label = { color = colors.white }
    })
    location:set({
      label = { color = colors.white }
    })
  end)
end)


sbar.exec([[
  bash -c '
    export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
    export LANG=en_US.UTF-8
    city=$(curl -s http://ip-api.com/json | jq -r .city)
    echo "$city"
    echo "$(curl -s "wttr.in/$city?format=%C+%t")"
  '
]], function(output)
  -- 将输出拆分为城市和天气信息
  local lines = {}
  for line in output:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  local city = lines[1] or "Unknown"
  local weather_str = lines[2] or ""

  -- 清理天气字符串
  weather_str = weather_str:gsub("%%%s*$", ""):gsub("\n", "")

  -- 提取天气和温度
  local condition, temp = string.match(weather_str, "([^%+]+)%s*%+?(-?%d+°[CF]?)")
  if condition then condition = condition:match("^%s*(.-)%s*$") end

  -- 匹配图标
  local icon = icons.weather.sunny
  if condition and temp then
    local cond = condition:lower()
    if cond:find("sun") or cond:find("clear") then
      icon = icons.weather.sunny
    elseif cond:find("cloud") or cond:find("overcast") then
      icon = icons.weather.cloudy
    elseif cond:find("rain") or cond:find("shower") then
      icon = icons.weather.rainy
    elseif cond:find("thunder") then
      icon = icons.weather.thunder
    elseif cond:find("snow") or cond:find("sleet") then
      icon = icons.weather.snow
    elseif cond:find("mist") or cond:find("fog") then
      icon = icons.weather.fog
    end

    weather:set({
      icon = { string = icon },
      label = { string = temp:gsub("^%+", "") }
    })
  else
    weather:set({
      icon = { string = icons.weather.sunny },
      label = { string = "N/A" }
    })
  end

  -- ✅ 设置城市标签
  location:set({
    label = { string = city }
  })
end)

sbar.add("item", { position = "right", width = settings.group_paddings, background = { color = colors.transparent, border_width = 0 }})