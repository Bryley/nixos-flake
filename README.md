# nixos-flake
My official NixOS and Home Manager flake containing all my dotfiles and system
configurations.


## Installation Guide

### Local

This is for when you are physically inside of a NixOS installer image and want
to install from the physical device.

Here are the steps:

1. Make sure the device has a connection to the internet
2. Set the root users password by typing `sudo passwd root`.
3. TODO...


### Remote

This flake also supports remote installation via SSH and nixos-anywhere.
Here are the steps to follow:

1. Make sure you have this repo cloned on your host system.
2. Add the machine (if it is not already added to `meta.toml`) using `just add <ip address>`.
3. Next install the distro by running `just install <name> <ip>`. This will run
   nixos-anywhere. Note that you may need to run it twice if it gets stuck.
4. 


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

