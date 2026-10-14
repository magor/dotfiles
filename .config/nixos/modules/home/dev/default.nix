{ pkgs, ... }:

# Development tooling for workstations; servers only get modules/home/common.
{
  imports = [
    ./neovim
  ];

  home.packages = with pkgs; [
    sshfs
    yt-dlp
    difftastic
    python3Packages.ipython
    jdk8
    cntr

    # direnv helper scripts
    # https://determinate.systems/posts/nix-direnv/
    # prepare devenv using remote flake
    (writeShellScriptBin "dvd" ''
      echo "use flake \"github:magor/dev-templates?dir=$1\"" >> .envrc
      direnv allow
    '')
    # prepare devenv by instantiating template locally
    # TODO: check https://github.com/magor/dev-templates/blob/main/flake.nix#L86
    (writeShellScriptBin "dvt" ''
      nix flake init --template "github:magor/dev-templates#$1"
      git init
      git add flake.nix
      direnv allow
    '')
  ];
}
