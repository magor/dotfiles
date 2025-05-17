{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # https://nixos.wiki/wiki/flakes#Importing_packages_from_multiple_channels
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix.url = "github:musnix/musnix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }@inputs:
  let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${prev.system};
    };
  in {
    nixosConfigurations = {
      gajdos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./hosts/gajdos
          ./modules/common
          ./modules/desktop
          ./modules/notebook.nix
          ./modules/virt.nix
          ./modules/docker.nix
          ./modules/gaming.nix
          ./modules/wine.nix
          ./modules/chyron.nix
          ./modules/looking-glass.nix
          ./modules/syncthing.nix
          ./modules/stylix.nix
          inputs.stylix.nixosModules.stylix
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
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./hosts/thinkpad
          ./modules/common
          ./modules/desktop
          ./modules/notebook.nix
          ./modules/chyron.nix
          ./modules/syncthing.nix
          ./modules/ide.nix
          ./modules/stylix.nix
          inputs.musnix.nixosModules.musnix

          nixos-hardware.nixosModules.lenovo-thinkpad-t14

          inputs.stylix.nixosModules.stylix

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
      CH-DC2HYZ2-CZ = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/CH-DC2HYZ2-CZ
          ./modules/common
          ./modules/desktop
          ./modules/notebook.nix
          ./modules/virt.nix
          ./modules/docker.nix
          ./modules/gaming.nix
          ./modules/wine.nix
          ./modules/chyron.nix
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
          home-manager.nixosModules.home-manager
        ];
      };
      virtmaster = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/virtmaster
          ./modules/common
          ./modules/server
          ./modules/virt.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
