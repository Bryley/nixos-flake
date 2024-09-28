{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # To get the wifi card working
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl88x2bu ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    forceFullCompositionPipeline = true;

    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    nvidiaSettings = true;
  };


  system.stateVersion = "24.11";

}

