{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # 2. Create a "media" group and add users to it
  users.groups.media = { };

  users.users.jellyfin.extraGroups = [
    "media"
    "render"
    #"video"
  ];
  users.users.mirek.extraGroups = [ "media" ];

  # 3. Create the directory with correct permissions automatically
  systemd.tmpfiles.rules = [
    # Syntax: Type Path Mode User Group Age Argument
    # 'd' creates a directory.
    # '2775' means read/write/execute for owner/group, and "setgid" (2) ensures
    # new files created inside inherit the 'media' group automatically.
    "d /home/media 2775 mirek media -"
    "d /home/media/movies 2775 mirek media -"
    "d /home/media/shows 2775 mirek media -"
  ];
}
