# nixos-flake
My official NixOS and Home Manager flake containing all my dotfiles and system
configurations.


## Installation Guide
(This is work in progress, has never been testing and should be treaded
carefully)

This assumes you have internet connection and are inside the fresh live ISO
image of NixOS.

1. First find out the name of the disk that you want to use using `lsblk`.
2. Next run the following command. This will use disko to partition, format and
   mount the drives for use: (Make sure to replace the end part with the path of
   the disk you found in the previous step like `/dev/nvme0n1`).

```
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode zap_create_mount --flake github:Bryley/nixos-flake#diskconfig --argstr diskName <disk name>
```

3. Now you can install the configuration. You can do this using the following
   command:

```
nixos-install --flake github:Bryley/nixos-flake#<host>
```

