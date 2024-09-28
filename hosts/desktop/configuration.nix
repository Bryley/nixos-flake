{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # To get the wifi card working
    extraModulePackages = with config.boot.kernelPackages; [ rtl88x2bu ];
    # TODO possibly remove this line
    kernelParams = [ "nvidia-drm.modeset=1" ];
  };

  modules.nvidia.enable = true;

  system.stateVersion = "24.11";

}
