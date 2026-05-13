#!/bin/bash

# Fetch all PIDs, filter out duplicates, and force kill them
hyprctl clients -j | jq -r '.[].pid' | sort -u | xargs -r kill

# Move to first workspace
hyprctl dispatch "hl.dsp.focus({ workspace = 1 })"
