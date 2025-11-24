{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      noto-fonts
      font-awesome
      #corefonts # ms free fonts
      #dejavu_fonts
      #google-fonts
      roboto
      roboto-mono # bitbucket web ui
      helvetica-neue-lt-std # used on web
      liberation_ttf
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
      localConf = ''
        <!-- use a less horrible font substition for pdfs such as https://www.bkent.net/Doc/mdarchiv.pdf -->
        <match target="pattern">
          <test qual="any" name="family"><string>Helvetica</string></test>
          <edit name="family" mode="assign" binding="same"><string>HelveticaNeueLTSTD</string></edit>
        </match>
      '';
    };
  };
}
