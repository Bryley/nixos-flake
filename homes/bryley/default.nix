{ inputs, pkgs, username, fullName, email, ... }:
{
  imports = [
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
        commit.template = "~/nixos-flake/configs/.gitmessage";
      };
    };

    hyprlock.enable = true;

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };

    nushell.enable = true;

    neovim = {
      enable = true;
      extraPackages = with pkgs; [
        # Compiling for Treesitter
        gcc
        curl
        pkg-config
        # openssl_3
        openssl

        # LSPs
        elmPackages.elm-language-server
        helm-ls
        htmx-lsp
        ltex-ls
        lua-language-server
        # nil
        nixd
        vscode-langservers-extracted
        basedpyright
        rust-analyzer
        tailwindcss-language-server
        yaml-language-server
        kdePackages.qtdeclarative # For qmlls
        # TODO add `vtsls` for typescript LSP (Add when https://github.com/NixOS/nixpkgs/pull/319501 request is done)
        typescript
        typescript-language-server

        # Formatters/Linters
        biome
        black
        elmPackages.elm-format
        mdformat
        # nixpkgs-fmt
        nixfmt-rfc-style
        nodePackages.prettier
        statix
        stylua
      ];
    };
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
