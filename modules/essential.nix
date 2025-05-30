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

    # Limit the number of generations to keep
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

    # TODO add applications for controling the sound with basic cli/gui tools
    # pavucontrol: controls the volume (per-sink and per-app basis), the default outputs/inputs, the different profiles (for HDMI outputs/bluetooth devices), routes each application to a different input/output, etc.
    # plasma-pa: a Plasma applet to change volume directly from the systray. Also deals with volume keys.
    # qjackctl: with JACK emulation, provides a patchbay (to connect applications together). Note that JACK does not provide any way to change the volume of a single application; use Pulseaudio tools for that purpose.
    # carla: with JACK emulation, provides a patchbay (make sure to go to "Patchbay" tab and check "Canvas > Show External").
    # catia/patchage: similar to qjackctl and carla.
    # Helvum: GTK-based patchbay for PipeWire (uses the PipeWire protocol). Volume control is planned for later.

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
