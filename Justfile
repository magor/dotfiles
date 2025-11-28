# inspiration:
# https://github.com/ryan4yin/nix-config/blob/main/Justfile

# show list of commands
default:
  @just --list

flake := "~/.config/nixos"

# common commands

# update all the flake inputs
up:
  nix flake update --flake {{flake}}

# update specific input (fe. `just upp nixpkgs`)
upp input:
  nix flake update --flake {{flake}} {{input}}

# clean all nix profiles, keep 5 generations
clean:
  nh clean all --keep 5 --ask

# rebuild and activate current configuration
switch:
  nh os switch {{flake}} --ask
# rebuild and activate dark configuration
switch-dark:
  nh os switch --no-specialisation {{flake}} --ask
# rebuild and activate light configuration
switch-light:
  nh os switch --specialisation light {{flake}} --ask

# rebuild and activate current homemanager configuration
home-switch:
  home-manager switch --flake {{flake}}

home-clean:
  $(readlink `which nh`) clean all --keep 5 --ask
