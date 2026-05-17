#!/bin/bash

if [ -f ~/.secrets ]; then
    source ~/.secrets
else
    CITY="Jakarta"
fi

text=$(curl -s "wttr.in/${CITY}?format=%c")
tooltip=$(curl -s "wttr.in/${CITY}?format=%c+%C+%t+(Feels+like+%f)\nWind:+%w\nHumidity:+%h\n")

jq -c -n \
  --arg text "$text" \
  --arg tooltip "$tooltip" \
  '{"text": $text, "tooltip": $tooltip}'
