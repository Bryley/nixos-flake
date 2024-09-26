{ inputs, pkgs, username, fullName, email, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
    ./files.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  programs.git = {
    enable = true;
    userName = fullName;
    userEmail = email;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull.rebase = "false";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    bun   # Needed for AGS
    sass  # Needed for AGS
  ];

  programs.ags = {
    enable = true;
    configDir = ../../configs/ags;
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # LSPs
      nil
      lua-language-server
      rust-analyzer
      nodePackages.vscode-json-languageserver
      yaml-language-server
      elmPackages.elm-language-server
      tailwindcss-language-server
      pyright
      htmx-lsp
      helm-ls
      ltex-ls
      # TODO add `vtsls` for typescript LSP (Add when https://github.com/NixOS/nixpkgs/pull/319501 request is done)

      # Formatters/Linters
      stylua
      nodePackages.prettier
      elmPackages.elm-format
      statix
    ];
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
