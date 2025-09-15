# inspiration:
# https://github.com/ryan4yin/nix-config/blob/main/Justfile

# common commands

## update all the flake inputs
up:
  nix flake update --flake .config/nixos

## Update specific input
## Usage: just upp nixpkgs
upp input:
  nix flake update --flake .config/nixos {{input}}

clean:
  nh clean all --keep 5 --ask

switch:
  nh os switch .config/nixos --ask
switch-dark:
  nh os switch --no-specialisation .config/nixos --ask
switch-light:
  nh os switch --specialisation light .config/nixos --ask
