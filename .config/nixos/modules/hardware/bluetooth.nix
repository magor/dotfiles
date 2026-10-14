{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        # https://nixos.wiki/wiki/Bluetooth#Showing_battery_charge_of_bluetooth_devices
        Experimental = true;
      };
    };
  };
}
