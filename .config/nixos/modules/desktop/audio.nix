{config, pkgs, ... }:

{
  musnix.enable = true;

  users.users.mirek.extraGroups = [ "audio" ];

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        #default.clock.rate = 48000;
        "default.clock.rate" = 44100; # fix rehearsal room drums jitter
        #"default.clock.quantum" = 128;
        #default.clock.min-quantum" = 32;
        #default.clock.max-quantum" = 512;
      };
    };
  };

  # sound/pipewire: rtkit is optional but recommended
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    qpwgraph
    pavucontrol
    spotify
    playerctl
    reaper
    vlc
    helvum
    qsynth
    fluidsynth
    soundfont-fluid
    carla
    helm
    drumgizmo
    hydrogen
    sfizz
    vital
    neural-amp-modeler-lv2
    qjackctl
  ];
}
