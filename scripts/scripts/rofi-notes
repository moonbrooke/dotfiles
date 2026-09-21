#!/usr/bin/env bash

folder=$HOME/notes/

newnote () { \
  dir="$(find "$folder" -maxdepth 1 -type d ! -name ".git" | rofi -dmenu -i -l 11 -p 'Choose directory: ' -theme-str 'window {width: 35%; border: 3px; border-color: #24283b;}')" || exit 0
  : "${dir:=$folder}"
  
  name="$(echo "" | rofi -dmenu -theme-str 'window {width: 35%; border: 3px; border-color: #24283b;} listview {lines: 0;}' -p "Enter a name: " <&-)" || exit 0
  : "${name:=$(date +%F_%H-%M-%S)}"
  
  setsid -f foot -e nvim "${dir%/}/$name.md" >/dev/null 2>&1
}

selected () { \
  choice=$(
    echo -e "New\n$(find "$folder" -name ".git" -prune -o -type f \( -name "*.md" -o -name "*.txt" \) -printf '%T@ %P\n' | sort -nr | cut -d' ' -f2-)" | rofi -dmenu -i -l 11 -p "Select note or write new one: " -theme-str 'window {width: 35%; border: 3px; border-color: #24283b;}'
  )
  case $choice in
    New) newnote ;;
    *.md|*.txt) setsid -f foot -e nvim "$folder$choice" >/dev/null 2>&1 ;;
    *) exit ;;
  esac
}

selected
