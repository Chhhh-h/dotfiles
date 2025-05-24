#!/bin/bash

# 获取当前输入法（使用 plist 解析）
layout_name=$(
  defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources |
  grep -A1 "KeyboardLayout Name" |
  grep -o '".*"' | sed -n '2p' | tr -d '"'
)

# 如果获取失败，可能是中文输入法，标注为“拼音”
if [[ -z "$layout_name" ]]; then
  layout_name="拼音"
fi

# 输出给 sketchybar
echo "sketchybar --set input_source label=\"$layout_name\""