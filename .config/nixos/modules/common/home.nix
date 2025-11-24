{
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mirek = {
      imports = [
        ../home
        inputs.nix-index-database.homeModules.nix-index
      ];
    };
  };
}
