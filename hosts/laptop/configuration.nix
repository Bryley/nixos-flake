{ ... }:

{
  imports = [ ];

  boot = {
    kernelParams = [
      "mt7921e.disable_aspm=1"
    ];
  };

  # modules.software.includeVirtualMachine = true;

  system.stateVersion = "24.11";
}
