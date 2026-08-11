{ pkgs, ... }:

# enable only on one system in your syncthing cluster!

# Quick Operations Reference
# ---------------------------
# 1. Verify timer is active:
#    systemctl --user list-timers | grep github-kb-backup
#
# 2. Trigger a manual test run:
#    systemctl --user start github-kb-backup.service
#
# 3. Check logs and execution output:
#    journalctl --user -u github-kb-backup.service -e -f

let
  kbPath = "/home/mirek/doc";
  sshKeyPath = "/home/mirek/.ssh/id_ed25519";
in
{
  # 1. Define the systemd backup service
  systemd.user.services.github-kb-backup = {
    Unit = {
      Description = "Automated Git Backup for Local Knowledge Base";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "backup-kb" ''
        export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"
        export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -i ${sshKeyPath} -o StrictHostKeyChecking=accept-new"

        cd ${kbPath} || exit 1

        # Check if there are changes to commit
        if [ -n "$(git status --porcelain)" ]; then
          git add .
          git commit -m "Auto-backup: $(date +'%Y-%m-%d %H:%M:%S')"
          git push origin main
        fi
      ''}";
    };
  };

  # 2. Define the timer to trigger the service periodically
  systemd.user.timers.github-kb-backup = {
    Unit = {
      Description = "Periodically back up Knowledge Base to GitHub";
    };
    Timer = {
      OnCalendar = "hourly"; # Options: "hourly", "*-*-* *:00/15" (every 15m), "daily"
      Persistent = true; # Run missed backups immediately on system boot
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
