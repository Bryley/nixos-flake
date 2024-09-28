{ lib, config, ... }:
let
  cfg = config.modules.nvidia;
in
{

  imports = [ ];

  options.modules.nvidia = {
    enable = lib.mkEnableOption "the use of nvidia for this PC";
    prime = {
      enable = lib.mkEnableOption "offloading support using prime";
      intelPci = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "1:0:0";
        description = "The Intel PCI Bus";
      };
      nvidiaPci = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "0:2:0";
        description = "The Nvidia GPU PCI Bus";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [ {
      assertion = !cfg.prime.enable || (cfg.prime.enable && cfg.prime.intelPci != "" && cfg.prime.nvidiaPci != "");
      message = "intelPci and nvidiaPci must be set when prime offloading is enabled.";
    } ];

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

      powerManagement.finegrained = lib.mkIf cfg.prime.enable true;

      # Enables offloading for better power management for laptops
      prime = {
        offload.enable = lib.mkIf cfg.prime.enable true;
        intelBusId = "PCI:${cfg.prime.intelPci}";
        nvidiaBusId = "PCI:${cfg.prime.nvidiaPci}";
      };

      nvidiaSettings = true;
    };
  };
}
