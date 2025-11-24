{
  home-manager,
  nix-index-database,
  ...
}:

{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mirek = {
      imports = [
        ../home
        nix-index-database.homeModules.nix-index
      ];
    };
  };
}
