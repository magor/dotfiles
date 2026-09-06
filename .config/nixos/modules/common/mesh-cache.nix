{ config, ... }:
let
  # Názvy vašich strojů v Tailscale MagicDNS
  allHosts = [
    "gajdos"
    "thinkpad"
    "shathak"
    "nixodeos"
  ];
  # Vyloučíme lokální stroj, aby se nedotazoval sám sebe
  otherHosts = builtins.filter (h: h != config.networking.hostName) allHosts;
in
{
  # 1. Harmonia server (poskytuje lokální store ostatním)
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ "/var/lib/harmonia/cache-priv.key" ];
    settings.bind = "[::]:5000";
  };

  # 2. Otevření portu 5000 VÝHRADNĚ na Tailscale rozhraní
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5000 ];

  # 3. Klientské nastavení Nixe
  nix.settings = {
    # Pokud stroj neodpoví napoprvé, neopakovat pokusy a jít hned na další cache
    download-attempts = 1;
    extra-substituters = map (h: "http://${h}:5000") otherHosts;
    extra-trusted-public-keys = [
      "mesh-cache-1:72hDEmxPyMHSUaFkF0M08idI33CwVu2npVLanENnBrI="
    ];

    # Zásadní volba: pokud desktop spí, vzdát pokus po 2 s a nezdržovat build
    connect-timeout = 2;
    fallback = true;
  };
}
