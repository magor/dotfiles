# see Autostart on login at https://wiki.archlinux.org/index.php/Sway#Tips_and_tricks
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  #XKB_DEFAULT_LAYOUT=us exec sway
  exec sway
fi
