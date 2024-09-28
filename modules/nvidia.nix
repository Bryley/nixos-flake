{ lib, config, ... }:
let
  cfg = config.modules.nvidia;
in
{

  imports = [ ];

  options.modules.nvidia = {
    enable = lib.mkEnableOption "Enables the use of nvidia for this PC";
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Tells wayland (and Xorg) to use nvidia drivers
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Use open source drivers (from Nvidia)
      open = true;
      # Often required for smooth rendering and reducing flickers.
      modesetting.enable = true;

      # Better power management
      powerManagement.enable = true;
      # powerManagement.finegrained = false;

      # Ensures tear-free experience, useful but can be turned off if no screen tearing.
      forceFullCompositionPipeline = true;

      # TODO, test if nessessary
      # Enables offloading for better power management for laptops
      # prime = {
      #   offload.enable = true;
      #   intelBusId = "PCI:0:2:0";
      #   nvidiaBusId = "PCI:1:0:0";
      # };

      nvidiaSettings = true;
    };
  };
}
