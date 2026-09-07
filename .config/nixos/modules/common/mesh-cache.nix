{ config, ... }:
let
  # Seznam strojů seřazený podle dostupnosti s přiřazenou prioritou:
  # (Nižší číslo = vyšší priorita; oficiální cache.nixos.org má prioritu 40)
  allCaches = [
    {
      host = "nixodeos";
      priority = 45;
    } # Server (běží nepřetržitě)
    {
      host = "shathak";
      priority = 60;
    } # Desktop
    {
      host = "thinkpad";
      priority = 65;
    } # Laptop
    {
      host = "gajdos";
      priority = 70;
    } # Laptop
  ];

  # Vyloučíme lokální uzel, aby se nedotazoval sám sebe
  remoteCaches = builtins.filter (c: c.host != config.networking.hostName) allCaches;
in
{
  # secrets configuration
  sops.secrets.harmonia_key = {
    sopsFile = ../../secrets/harmonia.yaml;
    mode = "0400";
  };

  # 1. Harmonia server (poskytuje lokální store ostatním)
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ config.sops.secrets.harmonia_key.path ];
    settings.bind = "[::]:5000";
  };

  # 2. Otevření portu 5000 VÝHRADNĚ na Tailscale rozhraní
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5000 ];

  # 3. Klientské nastavení Nixe
  nix.settings = {
    # Generování URL s explicitním parametrem priority
    extra-substituters = map (c: "http://${c.host}:5000?priority=${toString c.priority}") remoteCaches;

    extra-trusted-public-keys = [
      "mesh-cache-1:72hDEmxPyMHSUaFkF0M08idI33CwVu2npVLanENnBrI="
    ];

    # Zkrácení čekání na neodpovídající uzel na absolutní minimum jádra Nixe (1 s)
    connect-timeout = 1;

    # Neopakovat nezdařené pokusy a přejít rovnou k další cache / lokálnímu buildu
    download-attempts = 1;
    fallback = true;

    # Ukládání informace o neexistujících cestách (404 / timeout) na 30 minut,
    # aby se Nix při každém dalším balíčku v rámci session neptal vypnutého stroje znovu
    narinfo-cache-negative-ttl = 1800;
  };
}
