{ lib, config, options, pkgs, inputs, hostname, ... }: {

  imports = [
    ./essential.nix
    ./software.nix
    ./nvidia.nix
  ];

  modules = {
    essential.enable = lib.mkDefault true;
    software.enable = lib.mkDefault true;
    nvidia.enable = lib.mkDefault false;
  };
}
