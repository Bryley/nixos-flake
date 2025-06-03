{ config, ... }:
let
  dir = ../../configs;
in
{
  home.file = {
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-flake/configs/hypr";
      recursive = true;
    };
    ".config/nushell" = {
      source = dir + "/nushell";
      recursive = true;
    };
    ".config/nvim" = {
      # source = dir + "/nvim";
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-flake/configs/nvim";
      # recursive = true;
    };
    ".config/zellij" = {
      source = dir + "/zellij";
      recursive = true;
    };
    ".config/kitty" = {
      source = dir + "/kitty";
      recursive = true;
    };
    ".config/mutt" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-flake/configs/neomutt";
    };
    ".mbsyncrc" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-flake/configs/neomutt/mbsyncrc";
    };
    ".config/qutebrowser" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-flake/configs/qutebrowser";
    };
  };
}
