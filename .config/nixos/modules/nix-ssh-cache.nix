{ pkgs, ... }:

let
  pushHook = pkgs.writeShellScript "nix-post-build-push-nixodeos" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # Nix provides OUT_PATHS as a space-separated list of built store paths
    if [ -z "''${OUT_PATHS:-}" ]; then
      exit 0
    fi

    echo "[nix-post-build] Pushing paths to nixodeos: $OUT_PATHS" >&2

    # Don't let failures break the build:
    set +e
    ${pkgs.nix}/bin/nix copy --to ssh://nix-ssh@nixodeos $OUT_PATHS
    status=$?
    set -e

    if [ "$status" -ne 0 ]; then
      echo "[nix-post-build] WARNING: nix copy to nixodeos failed (exit $status), continuing anyway." >&2
    fi

    # Always succeed from Nix's point of view
    exit 0
  '';
in
{
  nix.settings = {
    # Keep the regular build setup (you don't enable distributedBuilds)
    # but add the hook:
    post-build-hook = "${pushHook}";

    # prepend ssh cache, keep the official cache
    substituters = [
      #"ssh://nix-ssh@nixodeos" # or ssh://nix-ssh@nixodeos.lan
      #"https://cache.nixos.org/" # enabled by default
    ];

    # Your cache’s public signing key from step 1.1:
    #trusted-public-keys = [
    #  "nixodeos-1:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    #  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #];

    #trusted-users = [
    #  "root"
    #  "mirek"
    #];
  };
}
