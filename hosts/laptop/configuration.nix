# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Needed for best performance with wifi card
    kernelModules = [ "iwlwifi" ];
    kernelParams = [ "iwlwifi.11n_disable=1" "iwlwifi.swcrypto=1" ];
  };

  modules.nvidia = {
    enable = true;
    prime = {
      enable = true;
      intelPci = "0:2:0";
      nvidiaPci = "1:0:0";
    };
  };

  # # TODO get working: Setup login screen
  # services.displayManager = {
  #   enable = true;
  #   sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #     theme = "astronaut";
  #   };
  # };

  system.stateVersion = "24.11";

}
