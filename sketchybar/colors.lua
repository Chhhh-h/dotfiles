return {
  black = 0xff181819,
  white = 0xffffffff,
  red = 0xfffc5d7c,
  green = 0xffa6e3a1,
  sky = 0xff89dceb,
  blue = 0xff89b4fa,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  pink = 0xffff8cb0,
  lavender = 0xa0b4befe,
  mauve = 0xffcba6f7,
  transparent = 0x00000000,

  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490
  },
  bg1 = 0xb0494d64,
  bg2 = 0x00414550,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
