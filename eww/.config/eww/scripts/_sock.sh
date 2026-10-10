#!/usr/bin/env bash
# Resolves Hyprland IPC sockets. Sets: SOCK (hyprctl) and SOCK2 (events).
# Falls back to the newest instance dir when HYPRLAND_INSTANCE_SIGNATURE is unset.

_RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

_DIR=""
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    _DIR="$_RUNTIME/hypr/$HYPRLAND_INSTANCE_SIGNATURE"
fi

if [ ! -S "$_DIR/.socket2.sock" ]; then
    _DIR=""
fi

if [ -z "$_DIR" ]; then
    _sock2=$(ls -t "$_RUNTIME"/hypr/*/.socket2.sock 2>/dev/null | head -1)
    if [ -n "$_sock2" ]; then
        _DIR=$(dirname "$_sock2")
    fi
fi

SOCK="$_DIR/.socket.sock"
SOCK2="$_DIR/.socket2.sock"
