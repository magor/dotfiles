{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    helix.url = "github:helix-editor/helix/master";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.CH-DC2HYZ2-CZ = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        # Set all inputs parameters as special arguments for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
        { _module.args = { inherit inputs; }; }
      ];
    };
  };
}
