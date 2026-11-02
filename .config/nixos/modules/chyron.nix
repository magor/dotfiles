{ pkgs, ... }:

{
  services.teamviewer.enable = true; # client doesn't work without running service :(
  environment.systemPackages = with pkgs; [
    obsidian
    parsec-bin
    remmina
  ];

  # teamviewerd only picks up logind sessions present when it starts, and it starts
  # before the tty1 login, so the client gets "session not found". Restart it once
  # the graphical session is up.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "teamviewerd.service" &&
          action.lookup("verb") == "restart" &&
          subject.user == "mirek") {
        return polkit.Result.YES;
      }
    });
  '';

  home-manager.users.mirek.systemd.user.services.teamviewerd-restart = {
    Unit = {
      Description = "Restart teamviewerd so it sees the graphical session";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart teamviewerd.service";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
