{
  inputs,
  lib,
  config,
  system,
  pkgs,
  ...
}:
{
  imports = [ ];

  config = lib.mkMerge [
    {
      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        # Essential CLI tools
        git
        jujutsu
        nix-output-monitor
        just
        fastfetch
        zip
        unzip
        file
        wget
        curl
        bat
        fzf
        jq
        fd
        ripgrep
        nmap
        usbutils
        gopass
        nushell
        carapace
        distrobox
        pinentry-curses
        virtualgl
        gum
        ncdu

        # Secrets/Encryption
        openssl
        gnupg
        age
        sops
        bitwarden-cli

        # Essential TUI tools
        zellij
        yazi
        sc-im

        # Extra tools
        typst
        llm
        (python313.withPackages (
          ps: with ps; [
            rich
            virtualenv
            pyyaml
            adblock
          ]
        ))
      ];

      programs = {
        gnupg.agent = {
          enable = true;
          enableSSHSupport = false;
          pinentryPackage = pkgs.pinentry-curses;
        };
        ssh = {
          extraConfig = ''
            AddKeysToAgent yes
            IdentitiesOnly yes
          '';
        };
      };

      # TODO maybe have `production` meta host attribute to setup firewall and
      # postgres for dev vs non-dev
      services = {
        postgresql = {
          enable = true;
          authentication = ''
            # Allow everyone on (dev only)
            local   all   all                 trust
          '';
          package = pkgs.postgresql_16;
          extensions = with pkgs.postgresql_16.pkgs; [
            pgvecto-rs # provides the "vectors" extension
          ];
          settings.shared_preload_libraries = "vectors.so";
          initialScript = pkgs.writeText "init-sql-script" ''
            CREATE EXTENSION IF NOT EXISTS vectors;
          '';
        };
      };

      virtualisation = {
        docker.enable = true;
        docker.daemon.settings.features.cdi = true;
      };
    }

    (lib.mkIf (!config.modules.essential.headless) {
      environment.systemPackages = with pkgs; [
        # CLI
        brightnessctl

        # GUI
        bitwarden-desktop
        evince
        xournalpp
        gimp
        inkscape
        hurl
        obsidian

        postgresql_16

        aseprite
        ldtk
        goxel

        # Wayland
        kitty
        hyprlock
        wl-clipboard
        hypridle
        swww
        wofi
        lxqt.lxqt-policykit
        inputs.quickshell.packages."${system}".default
        inputs.zen-browser.packages."${system}".default

        # VM
        qemu_kvm
        libvirt
        virt-manager
      ];

      # TODO configure LY display manager

      programs = {
        niri.enable = true;
      };

      fonts.packages = with pkgs; [
        nerd-fonts.hack
        nerd-fonts.ubuntu
        nerd-fonts.caskaydia-mono
      ];
    })
  ];
}
