# todo
- add desktop ssh key to nixodeos!!
- declaratively configure syncthing backup

# nice-to-have
- statistics per node (maybe netdata stats with metrics collector at nixodeos)
- installation readme
- separate subvolume for home and nix
- expand partition (unallocated space before /)

# maybe
- move to sway
- fix cursor (hyprcursor, firefox, different sizes)
- docker alias: prepare some info shell prompt


# remove channels
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
