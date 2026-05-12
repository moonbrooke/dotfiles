#!/usr/bin/env bash

folder=$HOME/notes/

newnote () { \
  dir="$(find "$folder" -maxdepth 1 -type d | rofi -dmenu -i -l 5 -p 'Choose directory: ')" || exit 0
  : "${dir:=$folder}"
  
  name="$(echo "" | rofi -dmenu -theme-str 'listview {lines: 0;}' -p "Enter a name: " <&-)" || exit 0
  : "${name:=$(date +%F_%H-%M-%S)}"
  
  setsid -f foot -e nvim "${dir%/}/$name.md" >/dev/null 2>&1
}

selected () { \
  choice=$(
    echo -e "+ New\n$(find "$folder" -type f -printf '%T@ %P\n' | sort -nr | cut -d' ' -f2-)" | rofi -dmenu -i -l 5 -p "Select note or write new one: "
  )
  case $choice in
    New) newnote ;;
    *.md) setsid -f foot -e nvim "$folder$choice" >/dev/null 2>&1 ;;
    *) exit ;;
  esac
}

selected
