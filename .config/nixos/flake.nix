{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # https://nixos.wiki/wiki/flakes#Importing_packages_from_multiple_channels
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix.url = "github:musnix/musnix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      gajdos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        modules = [
          ./hosts/gajdos
          ./modules/common
          ./modules/desktop
          ./modules/laptop.nix
          ./modules/virt.nix
          ./modules/docker.nix
          ./modules/gaming.nix
          ./modules/wine.nix
          ./modules/chyron.nix
          ./modules/ide.nix
          ./modules/looking-glass.nix
          ./modules/syncthing.nix
          ./modules/stylix.nix
          inputs.stylix.nixosModules.stylix
          inputs.musnix.nixosModules.musnix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        modules = [
          ./hosts/thinkpad
          ./modules/common
          ./modules/desktop
          ./modules/laptop.nix
          ./modules/chyron.nix
          ./modules/syncthing.nix
          ./modules/ide.nix
          ./modules/stylix.nix
          ./modules/gaming.nix
          inputs.musnix.nixosModules.musnix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      CH-DC2HYZ2-CZ = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        modules = [
          ./hosts/CH-DC2HYZ2-CZ
          ./modules/common
          ./modules/desktop
          ./modules/laptop.nix
          ./modules/virt.nix
          ./modules/docker.nix
          ./modules/gaming.nix
          ./modules/wine.nix
          ./modules/chyron.nix
          inputs.musnix.nixosModules.musnix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      nixodeos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixodeos
          ./modules/common
          ./modules/server
          inputs.home-manager.nixosModules.home-manager
        ];
      };
      virtmaster = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/virtmaster
          ./modules/common
          ./modules/server
          ./modules/virt.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
