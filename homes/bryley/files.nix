{ ... }:
let
  dir = ../../configs;
in
{
  home.file = {
    ".config/hypr" = {
      source = dir + "/hypr";
      recursive = true;
    };
    ".config/nushell" = {
      source = dir + "/nushell";
      recursive = true;
    };
    ".config/nvim" = {
      source = dir + "/nvim";
      recursive = true;
    };
    ".config/zellij" = {
      source = dir + "/zellij";
      recursive = true;
    };
    ".config/kitty" = {
      source = dir + "/kitty";
      recursive = true;
    };
  };
}
