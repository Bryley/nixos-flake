{ lib, config, options, pkgs, inputs, hostname, ... }: {

  imports = [
    ./essential.nix
    ./software.nix
  ];

  modules.essential.enable = lib.mkDefault true;
  modules.software.enable = lib.mkDefault true;

}
