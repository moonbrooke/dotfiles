#!/usr/bin/env bash

rofimoji \
    --action copy \
    --skin-tone neutral \
    --max-recent 10 \
    --files emojis math \
    --selector-args="-p 'Select Emoji: ' -lines 10 -theme-str 'window {border: 3px; border-color: #24283b;}'" \
