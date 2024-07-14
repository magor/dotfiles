# How to use

## setup
```bash
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:magor/dotfiles.git
mv dotfiles/* . && mv dotfiles/.* . && mv dotfiles/.config/* .config && rm -rf dotfiles
git submodule init && git submodule update
# make alias if not using zsh:
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

## usage
simply use `config` alias instead of `git` to work with dotfiles repository from your home

## inspired by
- https://www.digitalocean.com/community/tutorials/how-to-use-git-to-manage-your-user-configuration-files-on-a-linux-vps#creating-a-configuration-directory-to-store-files
- https://git.sr.ht/~sircmpwn/dotfiles/tree/master
- https://wiki.archlinux.org/index.php/Dotfiles#Tracking_dotfiles_directly_with_Git
- https://www.atlassian.com/git/tutorials/dotfiles

## nix config symlinks
- install nixos
- cd ~
- mkdir -p .config/nixos
- cp -r /etc/nixos/* .config/nixos/
- sudo rm -r /etc/nixos/
- sudo ln -s .config/nixos/ /etc/nixos
- sudo ln -s `pwd`/.config/nixos/ /etc/nixos
