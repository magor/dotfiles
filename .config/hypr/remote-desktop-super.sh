#!/usr/bin/env bash
# Swallow bare Super presses only while a remote desktop window (TeamViewer, Remmina)
# is focused: otherwise it forwards a lone Win to the remote Windows on every $mainMod
# bind and opens the Start menu. Hyprland still tracks the modifier, so $mainMod binds work.

keys=(", Super_L" "SUPER, Super_L" ", Super_R" "SUPER, Super_R")
on=0

swallow() {
  [ "$1" = "$on" ] && return
  for k in "${keys[@]}"; do
    if [ "$1" = 1 ]; then
      hyprctl keyword bind "$k, exec, true"
    else
      hyprctl keyword unbind "$k"
    fi
  done >/dev/null
  on=$1
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
  while IFS= read -r line; do
    case $line in
      "activewindow>>TeamViewer,"* | "activewindow>>org.remmina.Remmina,"*) swallow 1 ;;
      "activewindow>>"*) swallow 0 ;;
      # reload drops runtime binds; they come back on the next focus change
      "configreloaded>>"*) on=0 ;;
    esac
  done
