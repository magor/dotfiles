{
  ...
}:

{
  sops = {
    defaultSopsFormat = "yaml";

    # private host key for secret decryption
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
