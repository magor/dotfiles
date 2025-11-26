{ ... }:

{
  nix.sshServe = {
    enable = true;
    write = true;
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIORx66OsbrlzcRXhZzrhJe4wzkOW1kiQDFsYxXgi29qh root@gajdos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZwTtxcXdVHsaayyy1DC8GE2BnFTHfPVLYOyN5rBV06 root@thinkpad"
    ];
  };
  nix.settings.trusted-users = [
    "root"
    "mirek"
    "nix-ssh"
  ];
}
