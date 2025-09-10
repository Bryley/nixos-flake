{ inputs, lib, pkgs, config, users, hostname, ... }:
let
  cfg = config.modules.essential;
in {
  imports = [];

  options.modules.essential = {
    enable = lib.mkEnableOption "Enables the essential options";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      # Pin flake registry to use nixpkgs
      registry.nixpkgs.flake = inputs.nixpkgs; # For flake commands
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # For legacy commands and nixd lsp
      settings.flake-registry = "${inputs.flake-registry}/flake-registry.json";
    };

    networking = {
      networkmanager.enable = true;
      hostName = hostname;
    };


    # Setup users
    users.users = builtins.listToAttrs (builtins.map (user:
      {
        inherit (user) name;
        value = {
          isNormalUser = true;
          description = user.fullName;
          extraGroups = ["wheel" "networkmanager" "syncthing" "docker"];
          shell = pkgs.nushell;
        };
      }
    ) users);

    time.timeZone = "Australia/Brisbane";

    i18n.defaultLocale = "en_AU.UTF-8";

    # Limit the number of generations
    boot.loader.systemd-boot.configurationLimit = 10;
    nix.settings.auto-optimise-store = true;

    # Sound (see https://wiki.nixos.org/wiki/PipeWire)
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware = {
      # Bluetooth (see: https://wiki.nixos.org/wiki/Bluetooth)
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;

      # Used to hopefully increase battery life
      enableAllFirmware = true;
    };
    services.blueman.enable = true; # GUI for bluetooth

    # Enable the lock service to work
    security.pam.services.hyprlock = {};

    # Disable Firewall entirely (TODO stricter rules with the firewall)
    networking.firewall.enable = false;
  };
}
