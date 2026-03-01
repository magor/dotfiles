# Nix flake overview

This directory contains the Nix flake that assembles NixOS systems and Home Manager profiles. The `flake.nix` file defines a helper `mkSystem` function that standardizes host builds by wiring in shared overlays, library extensions, and optional Home Manager support. Everything here targets `x86_64-linux`.

## Inputs
- Stable `nixpkgs` plus an `nixos-unstable` channel exposed as `pkgs.unstable`
- Home Manager 25.05
- Stylix theming modules
- Musnix, firefox-nightly overlay, and nix-index database
- Optional `nixos-hardware` modules pulled in by hosts

## Workflow
- Hosts are declared under `nixosConfigurations` using `mkSystem`. Key arguments:
  - `hostName`: picks the matching entry from `./hosts`.
  - `modules`: extra machine-specific modules.
  - `homeModules`: additional Home Manager modules for the `mirek` user.
  - `allowUnfree`: opt into unfree software per host (defaults to true for desktops, disabled for servers).
  - `overlays`: append host-specific overlays on top of the shared defaults.
  - `enableHomeManager`: toggle Home Manager support when a host does not need user state.
  - `extraSpecialArgs`: pass extra arguments into NixOS modules without touching the shared defaults.
- Shared overlays expose `pkgs.unstable` and a nightly Firefox build; host overlays can further override packages (e.g., the `gajdos` desktop tracks `wezterm` from unstable).
- Library extensions live in `./lib`, including `lib.custom.scanPaths` which feature modules use to auto-import nested configs.

## Home Manager structure
- Common user configuration lives under `./modules/home/common`, with optional desktop additions in `./modules/home/desktop`.
- Zsh now sources shared aliases and functions from `~/.config/zsh` files managed by Home Manager, keeping the prompt consistent across hosts. Helpers cover project navigation (`mkcd`, `cproj`, `cflake`) and quick setup commands (`nhm`, `nixclean`).
- Helper scripts `dvd` and `dvt` are provided via `home.packages` to bootstrap direnv-enabled development environments from `magor/dev-templates`.

## Applying changes
- Run `nh os switch ~/.config/nixos` (or `nixos-rebuild switch --flake .#<host>`) to rebuild a host after editing modules or host definitions.
- Add new modules under `./modules`, then include them in a host’s `modules` or `homeModules` lists as needed.
