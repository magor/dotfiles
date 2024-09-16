# inspiration:
# https://github.com/ryan4yin/nix-config/blob/main/Justfile

# common commands

## update all the flake inputs
up:
  nix flake update .config/nixos

## Update specific input
## Usage: just upp nixpkgs
upp input:
  nix flake update {{input}}

## clean
clean:
  # https://nixos.wiki/wiki/Storage_optimization
  bin/trim-generations.sh || echo $?
  nix-store --gc
  sudo nix-store --gc
  sudo nix-store --optimise
