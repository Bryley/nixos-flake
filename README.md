# nixos-flake
My official NixOS flake containing all my dotfiles and system configurations.

## Installation Guide

### Local

This is for when you are physically inside of a NixOS installer image and want
to install from the physical device.

Here are the steps:

1. Make sure the device has a connection to the internet
2. Set the root users password by typing `sudo passwd root`.
3. Next clone this repo using `git clone https://github.com/Bryley/nixos-flake.git`
4. Next open a shell with the required applications
   `nix-shell -p just nushell gum nix-output-monitor`
5. Add a ssh key using `ssh-keygen` if required.
6. Add the machine using `just add`
7. Install the setup using `just install <name>`
8. Set the root password then reboot into the main disk


### Remote

This flake also supports remote installation via SSH and nixos-anywhere.
Here are the steps to follow:

1. Make sure you have this repo cloned on your host system.
2. Add the machine (if it is not already added to `meta.toml`) using `just add <ip address>`.
3. Next install the distro by running `just install <name> <ip>`. This will run
   nixos-anywhere. Note that you may need to run it twice if it gets stuck.
4. Once that is done (it may take a little while), you should now be able to SSH
   into the machine as the root user without needing a password where you can
   set a root password with `passwd root`. This is where you can set the passwords
   manually for each user.

   > [!NOTE]
   > If it is giving you a remote host identification has changed warning when
   > trying to SSH in you might need to manually remove the security entry in
   > `~/.ssh/known_hosts` file and try the SSH command again.


### Cloning Repo

Once you have installed everything and got it up and running, next is to get a
new copy of this repo on the machine where you can make updates and install
software.

1. Clone this repo into a nice spot (I recommend `~/nixos-flake` for your
   main user). Make sure that it has the correct permissions for your main user.
2. You might have to make sure you have added your system to `meta.toml` if you
   haven't already. Check the file to see if you see the system you setup, if
   not then add it using `just add` and following the prompts.
2. After doing that make sure you have generated at least 1 SSH key using
   `ssh-keygen`.
3. Finally to get all the dotfile configs setup make sure you run
   `just setup-dotfiles`. This will create the symlinks in `~/.config`.


## Notes for VM testing

For testing the configuration in VM there can sometimes be a few issues
regarding changing IPs and BIOS settings. Here are descriptions of the different
problems you should be aware of when testing in VMs.

### UEFI issue

The first issue you may run into is using legacy booting with BIOS. However, most
computers will support the more modern UEFI. Although Nix gives you the option
to support both, I have only supported UEFI, so it is expected that the machine
you install it on is setup to use UEFI. As for VMs using Virt Manager, it can be
changed in the overview tab and should be done before creating your VM for the
first time.

### IP Changing

The other issue you might face is that the IP keeps changing when installing
remotely. This is due to nixos-anywhere after installing the distro, the best
way I found to get around this is to setup a custom Virtual Network in Virt
Manager with the following `ip` XML tag config (or something similar):

```xml
<network connections="1">
  <name>sticky</name>
  ...
  <ip address="192.168.100.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.100.128" end="192.168.100.254">
        <lease expiry="168" unit="hours"/>
      </range>
    </dhcp>
  </ip>
</network>
```

> [!NOTE]
> If you don't want to have to go through this, just keep in mind that you
> could do these commands if the IP address of the VM changes if you get locked
> out:
> 
> ```bash
> sudo virsh list --all        # find the domain name of your VM
> sudo virsh domifaddr <domain-name>
> ```

