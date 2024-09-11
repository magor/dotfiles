{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    musnix.url = "github:musnix/musnix";
    helix.url = "github:helix-editor/helix/24.03";

    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259&submodules=1"; # 0.42.0
    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?rev=0f594732b063a90d44df8c5d402d658f27471dfe&submodules=1"; # 0.43.0
    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # main
    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=v0.43.0";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.42.0";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      CH-DC2HYZ2-CZ = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/CH-DC2HYZ2-CZ
          ./modules/common
          ./modules/desktop
          ./modules/notebook.nix
          ./modules/virt.nix
          ./modules/gaming.nix
          inputs.musnix.nixosModules.musnix

          # Set all inputs parameters as special arguments for all submodules,
          # so you can directly use all dependencies in inputs in submodules
          # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
          { _module.args = { inherit inputs; }; }
        ];
      };
      nixodeos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixodeos
          ./modules/common
          ./modules/server
        ];
      };
      virtmaster = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/virtmaster
          ./modules/common
        ];
      };
    };
  };
}
