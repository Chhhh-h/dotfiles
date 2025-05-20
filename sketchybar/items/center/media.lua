local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local whitelist = {
	['Spotify'] = true,
	['Music'] = true,
	['Podcasts'] = true,
	['VLC'] = true,
	['IINA'] = true,
	['Arc'] = true
};

sbar.add("item", { 
  position = "center", 
  width = 240, 
  background = { color = colors.transparent, border_width = 0 }
})


local media_cover = sbar.add("item", {
  position = "center",
  background = {
    image = {
      string = "media.artwork",
    },
    color = colors.transparent,
  },
  label = { drawing = false },
  icon = { 
    drawing = false, 
    string = icons.media.play_pause,
    font = { size = 14 },
  },
  click_script = "nowplaying-cli togglePlayPause"
})

local media_info = sbar.add("item", {
  icon = {
    drawing = false,
    font = { size = 14 },
    color = colors.black,
    max_chars = 12,
  },
  label = { drawing = false },
  width = 0,
  position = "center",
  background = {
      color = colors.transparent,
      border_width = 0 
  }
})

local media_group = sbar.add("bracket", "media.group", {
  media_cover.name,
  media_info.name,
}, {
  background = {
      border_color = colors.pink,
      border_width = 2 }
})


media_cover:subscribe("media_change", function(env)
  if whitelist[env.INFO.app] then
    local is_playing = (env.INFO.state == "playing")
    local app_name = env.INFO.app

    local artist = env.INFO.artist or ""
    local title = env.INFO.title or ""

    -- 动态背景颜色设置
    local bg_color = colors.blue
    if app_name == "Spotify" then
      bg_color = colors.green
    elseif app_name == "Arc" then
      bg_color = colors.pink
    end

    if is_playing then
      -- 播放中：显示 + 展开
      sbar.animate("tanh", 30, function()
        media_info:set({
          icon = { 
            drawing = true,
            string = artist ~= "" and (artist .. "-" .. title) or title,
            width = "dynamic",
          },
        })
        media_group:set({
          drawing = true,
          background = { color = bg_color }
        })
      end)
    else
      -- 停止播放：收起 + 清空
      sbar.animate("tanh", 30, function()
        media_info:set({ 
          icon = { width = 0 },
        })
      end)
      
    end
  end
end)

media_cover:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 20, function()
    media_cover:set({
      icon = { drawing = true },
    })
  end)
end)

media_cover:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 20, function()
    media_cover:set({
      icon = { drawing = false },
    })
  end)
end)


-- media_cover:subscribe("mouse.clicked", function(env)
--   media_cover:set({ popup = { drawing = "toggle" }})
-- end)