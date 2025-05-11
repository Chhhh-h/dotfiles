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

local media_cover = sbar.add("item", {
  position = "left",
  background = {
    image = {
      string = "media.artwork",
    },
    color = colors.transparent,
  },
  label = { drawing = false },
  icon = { drawing = false },
  updates = true,
  popup = {
    align = "center",
    horizontal = true,
  },
  padding_right=0
})

local media_artist = sbar.add("item", {
  icon = { drawing = false },
  label = {
    font = { size = 10.0 },
    y_offset = 6,
    width = "dynamic",
  },
  width = 0,
  drawing = true,
  position = "left",
  background = {
      color = colors.transparent,
      border_width = 0 }
})

local media_title = sbar.add("item", {
  icon = { drawing = false },
  label = {
    font = {
      style = settings.font.style_map["Bold"],
      size = 12.0
    },
    padding_right = 5,
    y_offset = -6,
    width = "dynamic",
  },
  drawing = true,
  position = "left",
  background = {
      color = colors.transparent,
      border_width = 0 }
})


local media_group = sbar.add("bracket", "media_group", {
  media_cover.name,
  media_artist.name,
  media_title.name
}, {
  drawing = false
})

--sbar.add("item", {
--  position = "center",
--  width = 380,
--  background = {color = colors.transparent}
--})

sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.back },
  label = { drawing = false },
  click_script = "nowplaying-cli previous",
})
sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.play_pause },
  label = { drawing = false },
  click_script = "nowplaying-cli togglePlayPause",
})
sbar.add("item", {
  position = "popup." .. media_cover.name,
  icon = { string = icons.media.forward },
  label = { drawing = false },
  click_script = "nowplaying-cli next",
})

media_cover:subscribe("media_change", function(env)
  if whitelist[env.INFO.app] then
    local is_playing = (env.INFO.state == "playing")
    local app_name = env.INFO.app

    media_artist:set({ label = env.INFO.artist or "" })
    media_title:set({ label = env.INFO.title or "" })
    
    local bg_color = colors.blue  -- 默认蓝色
    if app_name == "Spotify" then
      bg_color = colors.green
    elseif app_name == "Arc" then
      bg_color = colors.pink
    end
    
    sbar.animate("easeInOutQuad", 20, function()
      media_group:set({
        drawing=true,
        background = {
          color = is_playing and bg_color or colors.bg1
        }
      })

      media_artist:set({
        label = { color = is_playing and colors.black or colors.white }
      })
      
      media_title:set({
        label = { color = is_playing and colors.black or colors.white }
      })
    end)
  end
end)

media_cover:subscribe("mouse.clicked", function(env)
  media_cover:set({ popup = { drawing = "toggle" }})
end)