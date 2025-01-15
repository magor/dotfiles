# see Autostart on login at https://wiki.archlinux.org/index.php/Sway#Tips_and_tricks
#if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
#  #XKB_DEFAULT_LAYOUT=us exec sway
#  #exec dbus-run-session sway # needed so dbus knows about sway
#  #exec bin/sway-run
#  exec Hyprland &> ~/.hypr.log
#fi

# https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#in-tty
if uwsm check may-start && uwsm select; then
	exec systemd-cat -t uwsm_start uwsm start default
fi
