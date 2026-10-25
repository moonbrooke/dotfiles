#!/bin/sh

sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal-gtk
killall xdg-desktop-portal
sleep 1
/usr/libexec/xdg-desktop-portal &
sleep 2
/usr/libexec/xdg-desktop-portal-gtk &
sleep 2
/usr/libexec/xdg-desktop-portal-hyprland &
