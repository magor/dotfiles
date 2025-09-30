# todo
- vim - compare configuration tools (lazyvim etc)
    - use virtual machines built with nix to compare loading times etc
- clean dotfiles (submodules etc)
- configure .ssh/config declaratively
- add desktop ssh key to nixodeos!!

## nice-to-have
- research remote deployment
- statistics per node (maybe netdata stats with metrics collector at nixodeos)
- installation readme
- separate subvolume for home and nix

## machines

### thinkpad
- trying out s3 sleep (see bios to change to win/linux s0xidle if needed)
    - add swap for hibernate/hybrid sleep?
- fix ppd-tuned profile mapping: https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/hardware/tuned.nix#L92

### gajdos
- virtualization
    - cpu pinning
- upgrade firmware: `fwupdmgr update` - do on ac power
- fix brightness setter (waybar config)
    - https://nixos.wiki/wiki/Backlight
    - https://github.com/Alexays/Waybar/issues/3302
- btrfs subvolumes (nix store, home, ...)

### nixodeos
- install byobu
- manage secrets (ie. samba creds)

## notes

### remove channels
```
$ nix-channel --list
nixpkgs https://nixos.org/channels/nixpkgs-unstable

$ sudo nix-channel --list
nixos https://nixos.org/channels/nixos-24.05
```

```
$ nix-channel --remove nixpkgs
uninstalling 'nixpkgs'

$ sudo nix-channel --remove nixos
uninstalling 'nixos-24.05'
```

### migrate zsh history
```
mv .zsh_history .local/share/zsh/history
```
