{ lib, ... }:
{

  imports = [
    ./disko.nix
    ./essential.nix
    ./users.nix
    ./software.nix
    ./nvidia.nix
  ];

  modules = {
    essential.headless = lib.mkDefault false;
    nvidia.enable = lib.mkDefault false;
  };
}
