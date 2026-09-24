# Start Hyprland on local tty1 login (no UWSM).
# https://wiki.hypr.land/Getting-Started/Master-Tutorial/#launching-hyprland
if [[ -o login ]] \
   && [ -z "$SSH_CONNECTION" ] \
   && [ -t 0 ] \
   && [ "$(tty)" = /dev/tty1 ] \
   && [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] \
   && command -v start-hyprland >/dev/null 2>&1; then
  exec start-hyprland &> ~/.hypr.log
  # Alternative: log to the journal instead of a file
  # exec systemd-cat -t hyprland start-hyprland
fi

# Auto-start byobu on SSH login:
# - only for SSH login shells
# - only if interactive (has a TTY)
# - not when running "ssh host cmd"
# - not if already inside tmux/screen
if [[ -o login ]] \
   && [ -n "$SSH_CONNECTION" ] \
   && [ -z "$SSH_ORIGINAL_COMMAND" ] \
   && [ -t 0 ] \
   && [ -z "$TMUX" ] && [ -z "$STY" ] \
   && command -v byobu >/dev/null 2>&1; then
  exec byobu
fi
