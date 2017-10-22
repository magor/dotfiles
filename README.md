# configs

Inspired by [this howto][1].

## How to use

- checkout
- symlink desired configuration files from checkouted directory to it's normal location, i.e.
```bash
ln -sr `pwd`/.gitconfig ~/.gitconfig
```

### solarized.vim

```bash
mkdir -p ~/.vim/colors
ln -sr `pwd`/solarized.vim/colors/solarized.vim ~/.vim/colors
```


[1]: https://www.digitalocean.com/community/tutorials/how-to-use-git-to-manage-your-user-configuration-files-on-a-linux-vps#creating-a-configuration-directory-to-store-files
