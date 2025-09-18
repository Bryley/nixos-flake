{
  lib,
  inputs,
  pkgs,
  meta,
  ...
}:
let
  dotfiles = [
    "nvim"
    "zellij"
    "niri"
    "nushell"
    "kitty"
    "qutebrowser"
    "quickshell"
  ];

  # Custom `nvim` binary with access to LSP and formatters
  nvimWithLsp =
    let
      lspBins = with pkgs; [
        # Compiling for Tree-sitter
        gcc
        curl
        pkg-config
        openssl

        # LSPs
        elmPackages.elm-language-server
        helm-ls
        htmx-lsp
        lua-language-server
        nixd
        vscode-langservers-extracted
        basedpyright
        rust-analyzer
        tailwindcss-language-server
        yaml-language-server
        kdePackages.qtdeclarative # For `qmlls`
        typescript
        typescript-language-server
        emmet-ls
        harper # Language checking for developers
        tinymist # Typst

        # Formatters/Linters
        biome
        black
        elmPackages.elm-format
        mdformat
        nixfmt-rfc-style
        nodePackages.prettier
        statix
        stylua
        djlint
      ];
    in
    pkgs.writeShellScriptBin "nvim" ''
    export PATH=${lib.makeBinPath lspBins}:$PATH
    exec ${pkgs.neovim}/bin/nvim "$@"
  '';
in
{
  imports = [];

  # Setup all new users (need to manually set password using root)
  users.users = builtins.listToAttrs (
    builtins.map (user: {
      inherit (user) name;
      value = {
        isNormalUser = true;
        description = user.fullName;
        shell = pkgs.nushell;
        extraGroups = [
          "networkmanager"
          "docker"
        ] ++ lib.optional user.admin "wheel";
      };
    }) meta.users
  );

  # Setup dot files as symlinks
  systemd.tmpfiles.rules = lib.optional (builtins.pathExists meta.location)
    (
      lib.flatten (builtins.map (userFull:
      let
        user = userFull.name;
        configDir = "/home/${user}/.config";
      in
      [ "d ${configDir} 0755 ${user} ${user} - -" ]
      ++ (
        builtins.map (name:
          "L+ ${configDir}/${name} - - - - ${meta.location}/configs/${name}"
        ) dotfiles
      )
      ) meta.users)
    );

  # TODO add Neovim LSP and formatters bundled into with Neovim e.g. custom Neovim package

  environment.sessionVariables = {  # set via PAM early in login
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  environment.systemPackages = [ nvimWithLsp ];
}
