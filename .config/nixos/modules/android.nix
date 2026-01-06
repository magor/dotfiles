{ pkgs, ... }:

{
  # Enable ADB and Fastboot
  programs.adb.enable = true;

  # Install Heimdall (the Odin alternative) and android-tools
  environment.systemPackages = with pkgs; [
    heimdall # For flashing Samsung firmware (Download Mode)
    heimdall-gui # Optional: if you prefer a GUI, but CLI is better
    android-tools # Contains adb and fastboot
  ];

  # Allow your user to use ADB without sudo
  users.users.mirek.extraGroups = [ "adbusers" ];
}
