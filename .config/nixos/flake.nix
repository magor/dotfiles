{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    musnix.url = "github:musnix/musnix";
    helix.url = "github:helix-editor/helix/24.03";
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
          ./modules/k8s.nix
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
    };
  };
}
