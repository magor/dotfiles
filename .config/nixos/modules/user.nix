{config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.mirek = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" ];
     shell = pkgs.zsh;
     packages = with pkgs; [
       #firefox
     ];
   };

  programs = {
    zsh.enable = true;
  };
}
