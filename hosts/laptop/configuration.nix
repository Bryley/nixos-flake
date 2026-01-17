{ pkgs, ... }:

{
  imports = [ ];

  boot = {
    # Latest Linux kernel has better support for WIFI drivers
    # kernelPackages = pkgs.linuxPackages_6_14;
    kernelParams = [
      "mt7925e.disable_aspm=1"
      # "amdgpu.dcdebugmask=0x610"
      # "amdgpu.gpu_recovery=1"
      # "amdgpu.abmlevel=0"
      # "amdgpu.dcdebugmask=0x40610"
    ];
  };

  networking = {
    enableIPv6 = false;

    networkmanager = {
      wifi.powersave = false;
      wifi.backend = "iwd";
    };
    wireless.iwd.settings = {
      General = {
        AddressRandomization = "network";
        # NM handles IP config when it manages iwd
        EnableNetworkConfiguration = false;
      };
      Settings = {
        AutoConnect = true;
      };
      Scan = {
        DisableRoamingScan = true;
      };
      Rank = {
        # Disable 6GHz (Wi-Fi 6E/7 band) entirely:
        BandModifier6GHz = 0.0;

        # If you want the “nuclear” test (forces 2.4GHz only):
        BandModifier5GHz = 0.0;
      };

      # Kill IPv6 inside iwd too (helps the “first load stalls” problem)
      Network = {
        EnableIPv6 = false;
      };

      # The important part: driver-specific quirks
      DriverQuirks = {
        # Don’t destroy/recreate wlan0 at daemon start
        DefaultInterface = "mt7925e";

        # Force power-save off at the iwd layer for this driver
        PowerSaveDisable = "mt7925e";
      };
    };
  };

  systemd.services.iwd = {
    wants = [ "sys-devices-pci0000:00-0000:00:02.3-0000:c3:00.0-net-wlan0.device" ];
    after = [ "sys-devices-pci0000:00-0000:00:02.3-0000:c3:00.0-net-wlan0.device" ];
  };

  systemd.services.NetworkManager = {
    wants = [
      "iwd.service"
      "sys-devices-pci0000:00-0000:00:02.3-0000:c3:00.0-net-wlan0.device"
    ];
    after = [
      "iwd.service"
      "sys-devices-pci0000:00-0000:00:02.3-0000:c3:00.0-net-wlan0.device"
    ];
  };

  # modules.software.includeVirtualMachine = true;

  system.stateVersion = "24.11";
}
