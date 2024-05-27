#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p nvd

set -x

nixos-rebuild switch --upgrade
nix-env --delete-generations 30d
nix-store --gc

files=$(find /nix/var/nix/profiles/system-* -maxdepth 1 -type l | sort -t- -k2,2 -n | tail -n2)
nvd diff ${files}
