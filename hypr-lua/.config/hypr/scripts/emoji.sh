#!/usr/bin/env bash

rofimoji \
    --action copy \
    --skin-tone neutral \
    --max-recent 10 \
    --files emojis math \
    --selector-args="-p 'Select Emoji: ' -lines 10"
