# How to use

## setup
```bash
cd $HOME
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:magor/dotfiles.git
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

## usage
simply use `config` alias instead of `git` to work with dotfiles repository from your home

# inspired by
[1]: https://www.digitalocean.com/community/tutorials/how-to-use-git-to-manage-your-user-configuration-files-on-a-linux-vps#creating-a-configuration-directory-to-store-files
[2]: https://git.sr.ht/~sircmpwn/dotfiles/tree/master
[3]: https://wiki.archlinux.org/index.php/Dotfiles#Tracking_dotfiles_directly_with_Git
[4]: https://www.atlassian.com/git/tutorials/dotfiles
