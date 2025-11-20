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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      # Extend lib with lib.custom
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
    in
    {
      nixosConfigurations = {
        gajdos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit lib;
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
            inputs.stylix.nixosModules.stylix
            inputs.musnix.nixosModules.musnix
          ];
        };
        thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
            inherit lib;
          };
          modules = [
            ./hosts/thinkpad
            ./modules/common
            ./modules/desktop
            ./modules/laptop.nix
            ./modules/chyron.nix
            ./modules/syncthing.nix
            ./modules/ide.nix
            ./modules/gaming.nix
            inputs.musnix.nixosModules.musnix
            #inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14 # uses tlp, conflicts with tuned
            inputs.stylix.nixosModules.stylix
          ];
        };
        nixodeos = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit lib;
          modules = [
            ./hosts/nixodeos
            ./modules/common
            ./modules/server
            inputs.stylix.nixosModules.stylix
          ];
        };
        virtmaster = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/virtmaster
            ./modules/common
            ./modules/server
            ./modules/virt.nix
          ];
        };
      };
      homeConfigurations."mirek" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          stylix.homeModules.stylix
          ./modules/home
        ];
      };
    };
}
