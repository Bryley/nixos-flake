{
  config,
  lib,
  inputs,
  name,
  meta,
  ...
}:
let
  cfg = config.modules.essential;
in
{
  imports = [ ];

  options.modules.essential = {
    headless = lib.mkEnableOption "If the computer is ran in headless mode (no GUI)";
  };

  config = lib.mkMerge [
    {
      boot = {
        loader.systemd-boot.enable = lib.mkDefault true;
        loader.efi.canTouchEfiVariables = lib.mkDefault true;
      };

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          flake-registry = "${inputs.flake-registry}/flake-registry.json";
          # Caching
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
        # Pin flake registry to use `nixpkgs`
        registry.nixpkgs.flake = inputs.nixpkgs; # For flake commands
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; # For legacy commands and `nixd` LSP
      };

      networking = {
        networkmanager.enable = true;
        networkmanager.wifi.powersave = false;
        hostName = name;
      };

      time.timeZone = "Australia/Brisbane";
      i18n.defaultLocale = "en_AU.UTF-8";

      # Limit the number of generations
      boot.loader.systemd-boot.configurationLimit = 10;
      nix.settings.auto-optimise-store = true;

      networking.firewall = {
        enable = true;

        # Allow these ports for local server testing
        allowedTCPPortRanges = [
          {
            from = 3000;
            to = 3010;
          }
          {
            from = 5000;
            to = 5010;
          }
        ];

        allowedTCPPorts = [ 22 ]; # For SSH
      };

      services = {
        openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "yes";
          };
        };
      };
      users.users.root.openssh.authorizedKeys.keys = meta.publicKeys;

      system.stateVersion = "24.11";
    }

    (lib.mkIf cfg.headless {
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
      services.blueman.enable = true; # GUI for Bluetooth

      # Enable the lock service to work
      security.pam.services.hyprlock = { };
    })
  ];
}
