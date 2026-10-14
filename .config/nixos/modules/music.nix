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
