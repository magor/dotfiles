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
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  # sound/pipewire: rtkit is optional but recommended
  security.rtkit.enable = true;
}
