{config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # https://nixos.wiki/wiki/Fonts#Installing_specific_fonts_from_nerdfonts
      (nerdfonts.override { fonts = [ "Hack" "FiraCode" "DroidSansMono" ]; })
      noto-fonts
      font-awesome
      #corefonts # ms free fonts
      #dejavu_fonts
      #google-fonts
    ];
    fontconfig = {
      antialias = true;
      hinting = {
        enable = true;
        #autohint = true;
      };
      subpixel = {
        rgba = "rgb";
      };
    };
  };
}
