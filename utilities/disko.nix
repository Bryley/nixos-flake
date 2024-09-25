# Note: Currently not used, TODO need to get up and running
{ inputs }:
{
  diskconfig = { config, pkgs, ... }@args:
    let
      diskName = args.diskName or throw "Need to include diskName argstr";
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices."${diskName}" = {
        partitions = {
          ESP = {
            start = "1MiB";
            end = "512MiB";
            type = "ef00"; # EFI System Partition
            filesystem = {
              format = "vfat";
              mountPoint = "/boot";
            };
          };
          root = {
            start = "512MiB";
            end = "-8GiB";
            type = "8300"; # Linux filesystem
            filesystem = {
              format = "ext4";
              mountPoint = "/";
            };
          };
          swap = {
            start = "-8GiB";
            end = "100%";
            type = "8200"; # Linux swap
          };
        };
      };
    };
}
