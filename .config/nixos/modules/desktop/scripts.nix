{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "list-keybinds" ''
      menu="wofi"
      menu_command="$menu --dmenu"
      # check if menu is already running
      if pidof $menu > /dev/null; then
        pkill $menu
      fi

      msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'
      keybinds=$(cat ~/.config/hypr/binds.conf | grep -E '^bind')

      # replace #modifier with SUPER in the displayed keybinds for rofi
      display_keybinds=$(echo "$keybinds" | sed 's/\$modifier/SUPER/g')

      # display the keybinds
      echo "$msg
      $keybinds" | $menu_command
    '')
  ];
}
