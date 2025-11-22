#!/usr/bin/env bash

sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
killall xdg-desktop-portal-gtk
killall xdg-desktop-portal-gnome
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal-gnome &
sleep 2
/usr/lib/xdg-desktop-portal-gtk &
