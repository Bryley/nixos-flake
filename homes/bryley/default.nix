{ inputs, pkgs, username, fullName, email, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
    ./files.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      bun # Needed for AGS
      sass # Needed for AGS
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    git = {
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

    hyprlock.enable = true;

    ags = {
      enable = true;
      configDir = ../../configs/ags;
    };

    neovim = {
      enable = true;
      extraPackages = with pkgs; [
        # LSPs
        elmPackages.elm-language-server
        helm-ls
        htmx-lsp
        ltex-ls
        lua-language-server
        nil
        nodePackages.vscode-json-languageserver
        pyright
        rust-analyzer
        tailwindcss-language-server
        yaml-language-server
        # TODO add `vtsls` for typescript LSP (Add when https://github.com/NixOS/nixpkgs/pull/319501 request is done)

        # Formatters/Linters
        biome
        black
        elmPackages.elm-format
        mdformat
        nixpkgs-fmt
        nodePackages.prettier
        nodePackages.prettier
        statix
        stylua
      ];
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
