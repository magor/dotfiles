{config, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerdfonts
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
