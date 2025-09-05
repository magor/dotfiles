{config, pkgs, ... }:

{
  # https://linrunner.de/tlp/index.html
  services.tlp = {
    enable = true;
    settings = {
      # check output of `tlp-stat -p --cdiff -s` command for possible values

      # https://linrunner.de/tlp/settings/processor.html#cpu-scaling-governor-on-ac-bat
      # amd-pstate | intel_pstate in active mode:
      # - performance
      # - powersave – default
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      #CPU_SCALING_GOVERNOR_ON_BAT = "performance"; # fixes audio stutters in bitwig, most notable when using touchpad

      # https://linrunner.de/tlp/settings/processor.html#cpu-energy-perf-policy-on-ac-bat
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      #CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      #CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # https://linrunner.de/tlp/settings/processor.html#cpu-min-max-perf-on-ac-bat
      CPU_MIN_PERF_ON_AC = 40;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 20;
      CPU_MAX_PERF_ON_BAT = 100;
    };
  };
}
