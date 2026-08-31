#!/bin/bash

sudo pacman -Syu --noconfirm

if uname -r | grep -q "zen"; then
    HEADERS="linux-zen-headers"
else
    HEADERS="linux-headers"
fi

sudo pacman -S nvidia-open-dkms nvidia-utils egl-wayland "$HEADERS" --noconfirm --needed
