{
  pkgs,
  musnix,
  ...
}:

{
  imports = [
    musnix.nixosModules.musnix
  ];

  musnix.enable = true;

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      #"default.clock.rate" = 48000; # default
      "default.clock.rate" = 44100; # fix rehearsal room drums jitter
      "default.clock.quantum" = 256;
      "default.clock.min-quantum" = 128;
      "default.clock.max-quantum" = 512;
    };
  };

  # UMC1820 reports a different iSerial on reconnect → Bitwig loses IO names.
  # Pin the serial so PipeWire node names (and Bitwig's mapping key) stay stable.
  # ID_ID matters most: PipeWire builds device.name from it, and 78-sound-card.rules
  # sets it from the original serial before this 99-local rule runs.
  # 3969025A = the ID that holds the named IO map in Bitwig prefs. See ~/doc/zkusebna/bitwig.md
  services.udev.extraRules = ''
    SUBSYSTEM=="sound", ATTRS{idVendor}=="1397", ATTRS{idProduct}=="0503", ENV{ID_SERIAL}="BEHRINGER_UMC1820_3969025A", ENV{ID_SERIAL_SHORT}="3969025A", ENV{ID_USB_SERIAL}="BEHRINGER_UMC1820_3969025A", ENV{ID_USB_SERIAL_SHORT}="3969025A", ENV{ID_ID}="usb-BEHRINGER_UMC1820_3969025A-00"
  '';

  environment.systemPackages = with pkgs; [
    bitwig-studio
    carla
    crosspipe
    drumgizmo
    fluidsynth
    helm
    hydrogen
    neural-amp-modeler-lv2
    pavucontrol
    playerctl
    qjackctl
    qpwgraph
    qsynth
    reaper
    reaper-reapack-extension
    sfizz
    soundfont-fluid
    vital
    yabridge
    yabridgectl
  ];
}
