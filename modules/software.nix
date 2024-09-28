{ inputs, lib, config, pkgs, ... }:
let
  requiredPkgs = with pkgs; [
    git # Version Control
    nh # NixOS helper commands
    home-manager # CLI tool for updating dotfiles
    just # Command runner
    fastfetch # Neofetch alternative
    zip # Zipping software
    unzip # unzipping software
    wget # Curl alternative
    file # Information about a file
    ripgrep # Grep alternative
    fd # Better find command
    bat # Better cat command
    fzf # Fuzzy finder cli
    jq # JSON parser for command line
    usbutils # USB tools like `lsusb`
    evince # PDF viewer
    xournalpp # PDF editor
    pavucontrol # Sound GUI application
    brightnessctl # Control screen brightness
    sddm-astronaut # SDDM login screen theme
    (python310.withPackages (ps: with ps; [ rich virtualenv pyyaml ])) # Python 3.10


    neovim # Text Editor
    nushell # Modern shell
    zellij # Modern terminal multiplexer
    distrobox # Basic docker wrapper for quick FHS system
  ];

  workPkgs = with pkgs; [
    gimp # Image editor
    inkscape # SVG editor
    hurl # Restful API tester
    dbeaver-bin # Database GUI
    obsidian # Note taking
    ngrok # Quick servers
  ];

  hyprlandPkgs = with pkgs; [
    wl-clipboard # Clipboard manager for Wayland
    hypridle # Idle daemon for automatically suspending computer after a certain amount of time
    kitty # Modern terminal emulator
    swww # Wallpaper daemon
    wofi # App launcher
    lxqt.lxqt-policykit # Polkit Authentication Agent
    inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default # Cursor theme
    inputs.zen-browser.packages."${system}".specific # Web browser # TODO update when in nixpkgs
  ];

  personalPkgs = [ ];

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
  };

  config = lib.mkIf cfg.enable {

    # Needed for obsidian
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = requiredPkgs
      ++ lib.optionals cfg.includeWork workPkgs
      ++ lib.optionals cfg.includeHyprland hyprlandPkgs
      ++ lib.optionals cfg.includePersonal personalPkgs;

    # Required Services
    services.openssh.enable = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" "Ubuntu" "CascadiaCode" ]; })
    ];

    # Work services
    virtualisation.docker.enable = lib.mkIf cfg.includeWork true;

    # Hyprland
    programs.hyprland.enable = lib.mkIf cfg.includeHyprland true;
    services.upower.enable = lib.mkIf cfg.includeHyprland true; # Needed for AGS

    # Personal
    programs.steam.enable = lib.mkIf cfg.includePersonal true;
  };
}
