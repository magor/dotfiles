{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix.url = "github:musnix/musnix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
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

          home-manager.nixosModules.home-manager
          #{
          #  home-manager = {
              #useGlobalPkgs = true;
              #useUserPackages = true;
              #users.jdoe = import ./home.nix; # done in users submodule

              # Optionally, use extraSpecialArgs to pass
              # arguments to home.nix
          #  };
          #}

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
          ./modules/virt.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
