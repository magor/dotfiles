{
  pkgs,
  ...
}:

let
  hostKey = "/etc/ssh/ssh_host_ed25519_key";
in
{
  sops = {
    defaultSopsFormat = "yaml";

    # private host key for secret decryption
    age.sshKeyPaths = [ hostKey ];
  };

  # Hosts without sshd (gajdos, thinkpad) never get a host key generated, so create it
  # before sops-nix decrypts. A new key still has to be added to .sops.yaml
  # (ssh-to-age < ${hostKey}.pub) and the secrets re-encrypted.
  system.activationScripts = {
    sopsHostKey.text = ''
      if [ ! -s ${hostKey} ]; then
        mkdir -p /etc/ssh
        ${pkgs.openssh}/bin/ssh-keygen -q -t ed25519 -N "" -f ${hostKey}
      fi
    '';
    setupSecrets.deps = [ "sopsHostKey" ];
  };
}
