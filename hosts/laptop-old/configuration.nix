# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ ... }:

{
  imports = [ ];

  boot = {
    # Needed for best performance with Wi-Fi card
    kernelModules = [ "iwlwifi" ];
    kernelParams = [
      "iwlwifi.11n_disable=1"
      "iwlwifi.swcrypto=1"
      "kvm-intel"
    ];
  };

  modules.nvidia = {
    enable = true;
    prime = {
      enable = true;
      intelPci = "0:2:0";
      nvidiaPci = "1:0:0";
    };
  };

  # modules.software.includeVirtualMachine = true;

  system.stateVersion = "24.11";
}
