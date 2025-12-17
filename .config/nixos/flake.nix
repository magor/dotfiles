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
      nix-index-database,
      stylix,
      musnix,
      firefox,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      mkPkgs =
        {
          allowUnfree,
          overlays,
        }:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = allowUnfree;
        };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      defaultOverlays = [
        (final: prev: {
          # make unstable and nightly firefox easily accessible
          unstable = pkgs-unstable;
          firefox-nightly = firefox.packages.${system}.firefox-nightly-bin;
        })
      ];
      # Extend lib with lib.custom
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });

      mkSystem =
        {
          hostName,
          modules ? [ ],
          homeModules ? [ ],
          allowUnfree ? true,
          overlays ? [ ],
          enableHomeManager ? true,
          extraSpecialArgs ? { },
        }:
        let
          pkgs = mkPkgs {
            inherit allowUnfree;
            overlays = defaultOverlays ++ overlays;
          };
          homeManagerModule = {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mirek = {
                imports = [
                  ./modules/home/common
                  nix-index-database.homeModules.nix-index
                ]
                ++ homeModules;
              };
            };
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit lib pkgs pkgs-unstable;
            inherit (inputs)
              stylix
              musnix
              home-manager
              nix-index-database
              ;
          } // extraSpecialArgs;
          modules = [
            # ensure NixOS uses our pre-imported pkgs
            (
              { ... }:
              {
                nixpkgs.pkgs = pkgs;
              }
            )
            ./hosts/${hostName}
            ./modules/common
          ]
          ++ lib.optionals enableHomeManager [
            home-manager.nixosModules.home-manager
            homeManagerModule
          ]
          ++ modules;
        };
    in
    {
      nixosConfigurations = {
        gajdos = mkSystem {
          hostName = "gajdos";
          overlays = [
            # keep wezterm following unstable releases on the desktop host
            (final: prev: { wezterm = pkgs-unstable.wezterm; })
          ];
          modules = [
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
          ];
          homeModules = [
            ./modules/home/desktop
          ];
        };
        thinkpad = mkSystem {
          hostName = "thinkpad";
          modules = [
            ./modules/desktop
            ./modules/laptop.nix
            ./modules/chyron.nix
            ./modules/syncthing.nix
            ./modules/ide.nix
            ./modules/gaming.nix
            #inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14 # uses tlp, conflicts with tuned
          ];
          homeModules = [
            ./modules/home/desktop
          ];
        };
        nixodeos = mkSystem {
          hostName = "nixodeos";
          allowUnfree = false;
          modules = [
            ./modules/server
          ];
          enableHomeManager = false;
        };
        virtmaster = nixpkgs.lib.nixosSystem {
          inherit hostName;
          allowUnfree = false;
          enableHomeManager = false;
          modules = [
            ./modules/server
            ./modules/virt.nix
          ];
        };
      };
      homeConfigurations."mirek" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs {
          allowUnfree = true;
          overlays = defaultOverlays;
        };
        modules = [
          stylix.homeModules.stylix
          ./modules/home/common
          ./modules/home/desktop
        ];
      };
    };
}
