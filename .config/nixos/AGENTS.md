# AGENTS.md - Dotfiles Repository (NixOS Context)

This file provides instructions for agents operating within the NixOS configuration directory (`.config/nixos`). To protect privacy and limit scope, this directory should be treated as the project root.

## Repository Structure (Relative to Root)

- `flake.nix`: Main flake entry point.
- `hosts/`: Host-specific definitions (gajdos, thinkpad, nixodeos, virtmaster).
- `modules/`: Feature-based modules (NixOS and Home Manager).
- `lib/`: Custom library helpers (e.g., `relativeToRoot`, `scanPaths`).
- `../../.config/hypr/`: Hyprland configuration (Accessed via relative path if needed).
- `../../Justfile`: Tasks for system management (Must be run from repo root).

## Build, Lint, and Test

### System Operations (Run from Repo Root)
- **Switch Configuration**: `just switch`
- **Theme Specializations**: `just switch-dark` or `just switch-light`.
- **Update Inputs**: `just up` or `just upp <input>`.
- **Cleanup**: `just clean`.

### Verification & Testing
- **Dry Run**: `sudo nixos-rebuild dry-activate --flake .`
- **VM Test**: `nixos-rebuild build-vm --flake .#<hostname>`
- **Expression Testing**: `nix repl -f .` then `:lf .` and `outputs.nixosConfigurations.thinkpad.config.services`.
- **Formatting**: `nix fmt`.

## Code Style & Conventions

### Nix Patterns
- **Helpers**: Use `lib.custom.relativeToRoot` for path referencing.
- **Module Structure**: Always use `{ config, lib, pkgs, ... }:` header.
- **Conditional Config**: Prefer `config = lib.mkIf config.feature.enable { ... };`.
- **mkSystem Wrapper**: When adding hosts, use the `mkSystem` helper in `flake.nix`.
- **Attribute Inheritance**: Use `inherit (pkgs) stdenv;`.

### Naming & Organization
- **Files**: `kebab-case.nix`.
- **Options**: `services.<name>.enable` for toggles.
- **Home Manager**: Integrated via NixOS modules. User-specific config lives in `modules/home/`.

## Critical Rules for Agents
1. **Scope**: Do not access files outside of `~/.config/` unless explicitly requested.
2. **Secrets**: **Do not commit plain-text secrets.**
3. **Hardware Config**: Do not manually edit `hardware-configuration.nix` files.
4. **Git Operations**: Use the `config` alias (defined as `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME`) to manage dotfiles. This is a bare repository (`$HOME/.dotfiles/`) with the work-tree set to `$HOME`, so files are "installed" in their actual locations across the home directory rather than a standard clone folder. Do not use standard `git` commands for dotfiles management.
5. **Path Construction**: Always verify the project root before building absolute paths.
