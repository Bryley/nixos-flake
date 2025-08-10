{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  requiredPkgs = with pkgs; [
    git # Version Control
    jujutsu # New version control
    nh # NixOS helper commands
    home-manager # CLI tool for updating dotfiles
    just # Command runner
    fastfetch # Neofetch alternative
    zip # Zipping software
    unzip # unzipping software
    wget # Curl alternative
    file # Information about a file
    pass # Password storer
    ripgrep # Grep alternative
    fd # Better find command
    bat # Better cat command
    fzf # Fuzzy finder cli
    jq # JSON parser for command line
    usbutils # USB tools like `lsusb`
    evince # PDF viewer
    nmap # Network port scanner
    xournalpp # PDF editor
    pavucontrol # Sound GUI application
    brightnessctl # Control screen brightness
    virtualgl # Some GPU commands `glxinfo` for instance
    (python313.withPackages (
      ps: with ps; [
        rich
        virtualenv
        pyyaml
        adblock
      ]
    )) # Python 3.10
    bitwarden-desktop # Password manager desktop application
    bitwarden-cli # Password manager cli
    isync # Mail server syncing
    aerc # Modern email client TUI

    neovim # Text Editor
    yazi # File selector TUI (used within neovim)
    sc-im # Vim-like spreadsheet editor
    nushell # Modern shell
    carapace # Command line autocompletion
    zellij # Modern terminal multiplexer
    pueue # Background task management
    neomutt # Email Client TUI
    distrobox # Basic docker wrapper for quick FHS system
    typst # Modern LaTeX alternative for writing documents
    llm # Large language models via command line
  ];

  workPkgs = with pkgs; [
    gimp # Image editor
    inkscape # SVG editor
    hurl # Restful API tester
    dbeaver-bin # Database GUI
    obsidian # Note taking
    ngrok # Quick servers
    surrealdb # SurrealDB cli tool
    surrealist # GUI for connecting to SurrealDB databases

    kubectl # Kubernetes CLI
    kubectx # Kubernetes Context Switch
    minikube # Kubernetes testing
    kubernetes-helm # Kubernetes package manager
    doctl # Digital Ocean CLI

    aseprite # Pixel art editor
    ldtk # Tile map editor
    goxel # Voxel editor

    postgresql # Postgres client
  ];

  hyprlandPkgs = with pkgs; [
    wl-clipboard # Clipboard manager for Wayland
    hypridle # Idle daemon for automatically suspending computer after a certain amount of time
    kitty # Modern terminal emulator
    swww # Wallpaper daemon
    wofi # App launcher
    rose-pine-hyprcursor # Cursor theme
    lxqt.lxqt-policykit # Polkit Authentication Agent
    inputs.quickshell.packages."${system}".default
    # TODO get this plugin system working
    # hyprlandPlugins.hyprsplit # Plugin for better workspace management
    # inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default # Cursor theme
    qutebrowser # Vim-like declarative browser
    inputs.zen-browser.packages."${system}".default # Web browser # TODO update when in nixpkgs
  ];

  personalPkgs = with pkgs; [
    prismlauncher
  ];

  virtualMachinePkgs = with pkgs; [
    qemu_kvm
    libvirt
    virt-manager
  ];

  cfg = config.modules.software;
in
{
  imports = [ ];

  options.modules.software = {
    enable = lib.mkEnableOption "the software module";

    includeWork = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Includes work utility related software, obsidian, inkscape, etc.";
    };

    includeHyprland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Hyprland and all required software";
    };

    includePersonal = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Adds personal packages like steam";
    };

    includeVirtualMachine = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Inlcude KVM virtual machine support";
    };
  };

  config = lib.mkIf cfg.enable {
    # Needed for obsidian
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages =
      requiredPkgs
      ++ lib.optionals cfg.includeWork workPkgs
      ++ lib.optionals cfg.includeHyprland hyprlandPkgs
      ++ lib.optionals cfg.includePersonal personalPkgs
      ++ lib.optionals cfg.includeVirtualMachine virtualMachinePkgs;

    # Required Services
    services.openssh = {
      enable = true;
    };

    programs.ssh = {
      startAgent = true;
      extraConfig = ''
        AddKeysToAgent yes
        IdentitiesOnly yes
      '';
    };

    fonts.packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.ubuntu
      nerd-fonts.caskaydia-mono
    ];

    # Enable the pueue task manager
    systemd.user.services.pueued = {
      enable = true;
      description = "Pueue Daemon";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.pueue}/bin/pueued";
        Restart = "always";
      };
    };

    # Work services
    virtualisation.docker.enable = lib.mkIf cfg.includeWork true;
    virtualisation.docker.daemon.settings.features.cdi = lib.mkIf cfg.includeWork true;

    services = {
      ollama = {
        enable = lib.mkIf cfg.includeWork true;
        # Optional: load models on startup
        loadModels = [ "llama3.2:3b" ];
        # TODO might need to create an option for `rocm` for AMD
        acceleration = "cuda";
      };
      upower.enable = lib.mkIf cfg.includeHyprland true; # Needed for AGS

      # Needed for disabling laptop monitor when closed
      logind = lib.mkIf cfg.includeHyprland {
        lidSwitch = "ignore"; # HandleLidSwitch=ignore
        lidSwitchDocked = "ignore"; # HandleLidSwitchDocked=ignore :contentReference[oaicite:3]{index=3}
        # If you want to be extra sure:
        extraConfig = ''
          HandleLidSwitchExternalPower=ignore
        '';
      };

      surrealdb = {
        enable = lib.mkIf cfg.includeWork true;
        dbPath = "surrealkv:///var/lib/surrealdb";
        extraFlags = [
          "--allow-all"
          "--user"
          "root"
          "--pass"
          "root"
        ];
      };

      displayManager.ly = {
        enable = true;
        settings = {
          animate = true;
          animation = "cmatrix";
          hide_borders = true;
          clock = "%c";
          bigclock = true;
        };
      };
    };
    # Required fix for surrealdb to work (For now)
    systemd.services.surrealdb.serviceConfig.ProcSubset = lib.mkForce "all";

    virtualisation.libvirtd.enable = lib.mkIf cfg.includeVirtualMachine true;

    users.groups.libvirtd = lib.mkIf cfg.includeVirtualMachine {
      members = [ "bryley" ];
    };

    # Hyprland
    programs.hyprland.enable = lib.mkIf cfg.includeHyprland true;
    # environment.sessionVariables = lib.mkIf cfg.includeHyprland {
    #   HYPRLAND_PLUGINS = "${pkgs.hyprlandPlugins.hyprsplit}/lib/hyprland/plugins";
    # };

    xdg.portal = {
      enable = lib.mkIf cfg.includeHyprland true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk # portal that reads your dconf dark-mode setting
      ];
    };

    qt.enable = lib.mkIf cfg.includeHyprland true;

    programs.dconf = {
      enable = lib.mkIf cfg.includeHyprland true;

      # 2. Add a “user” profile that writes our override
      profiles.user.databases = [
        {
          # lockAll = true prevents any other tool from overriding
          lockAll = true;

          # these are the GSettings paths → values
          settings = {
            "org/gnome/desktop/interface" = {
              # possible values: "default" | "prefer-light" | "prefer-dark"
              color-scheme = "prefer-dark";
            };
          };
        }
      ];
    };

    # Personal
    programs.steam.enable = lib.mkIf cfg.includePersonal true;
  };
}
