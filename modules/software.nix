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

  config =
    lib.mkMerge [
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
          cmake
          ripgrep
          pandoc
          tectonic
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
          ffmpeg
          (import ./pkgs/streamdown.nix { inherit pkgs; })

          # Secrets/Encryption
          openssl
          gnupg
          age
          sops
          bitwarden-cli

          # Essential TUI tools
          tmux
          zellij
          yazi
          sc-im
          presenterm

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
        # Postgres for dev vs non-dev
        services = {
          # Needed for battery utilities
          upower.enable = true;

          postgresql = {
            enable = true;
            authentication = ''
              # Allow everyone on (dev only)
              local   all   all                 trust
            '';
            package = pkgs.postgresql_16;
            extensions = with pkgs.postgresql_16.pkgs; [
              pgvecto-rs # provides the "vectors" extension
              postgis # Provides geo-spacial extension
              pg_cron # Cronjobs inside of PG
            ];
            settings = {
              shared_preload_libraries = "vectors,pg_cron";
              "cron.database_name" = "fynd";
            };
            initialScript = pkgs.writeText "init-sql-script" ''
              CREATE EXTENSION IF NOT EXISTS vectors;
              CREATE EXTENSION IF NOT EXISTS postgis;
              CREATE EXTENSION IF NOT EXISTS pg_cron;
            '';
          };
          seatd.enable = true;
        };

        virtualisation = {
          docker.enable = true;
          docker.daemon.settings.features.cdi = true;
          libvirtd.enable = true;
        };
      }

      (lib.mkIf (!config.modules.essential.headless) {
        environment.systemPackages = with pkgs; [
          # CLI
          brightnessctl

          # GUI
          xwayland-satellite # Required for XWayland applications in Niri
          bitwarden-desktop
          evince
          xournalpp
          gimp
          inkscape
          hurl
          obsidian
          vlc
          zoom-us
          obs-studio

          postgresql_16

          # aseprite # TODO re-enable later due to it failing the build process
          ldtk
          goxel

          # Wayland
          kitty
          hyprlock
          wl-clipboard
          wf-recorder
          # hypridle
          swayidle
          swww
          wofi
          lxqt.lxqt-policykit
          inputs.quickshell.packages."${system}".default
          inputs.zen-browser.packages."${system}".default
          brave

          # VM
          qemu_kvm
          libvirt
          virt-manager
        ];

        # TODO configure LY display manager

        programs = {
          niri.enable = true;
        };

        # systemd.user.services.idle = {
        #   wantedBy = [ "graphical-session.target" ];
        #   serviceConfig.ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.hyprlock}/bin/hyprlock' timeout 900 '${pkgs.systemd}/bin/systemctl suspend'";
        # };

        fonts.packages = with pkgs; [
          nerd-fonts.hack
          nerd-fonts.ubuntu
          nerd-fonts.caskaydia-mono
        ];
      })
    ];
}
