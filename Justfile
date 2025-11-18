# inspiration:
# https://github.com/ryan4yin/nix-config/blob/main/Justfile

# show list of commands
default:
  @just --list

# common commands

# update all the flake inputs
up:
  nix flake update --flake .config/nixos

# update specific input (fe. `just upp nixpkgs`)
upp input:
  nix flake update --flake .config/nixos {{input}}

# clean all nix profiles, keep 5 generations
clean:
  nh clean all --keep 5 --ask

# rebuild and activate current configuration
switch:
  nh os switch .config/nixos --ask
# rebuild and activate dark configuration
switch-dark:
  nh os switch --no-specialisation .config/nixos --ask
# rebuild and activate light configuration
switch-light:
  nh os switch --specialisation light .config/nixos --ask

# rebuild and activate current homemanager configuration
home-switch:
  home-manager switch --flake ~/.config/nixos
