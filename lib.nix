{ inputs, meta }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  buildSystem =
    {
      name,
      system,
      disk,
      headless,
    }:
    let
      paths = [
        ./hosts/${name}/configuration.nix
        ./hosts/${name}/hardware-configuration.nix
        ./generated-hardware-configuration.nix
      ];
    in
    {
      inherit name;
      value = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit name disk system inputs meta;
        };
        modules =
          (builtins.concatLists (builtins.map (path: lib.optional (builtins.pathExists path) path) paths))
          ++ [
            ./modules
            (_: {
              modules.essential.headless = headless;
            })
          ];

        # modules = [
        #   ./modules
        #   (_: {
        #     modules.essential.headless = headless;
        #   })
        # ]
        #   ++ lib.optional (builtins.pathExists configPath) configPath
        #   ++ lib.optional (builtins.pathExists hardwareConfigPath) hardwareConfigPath;
      };
    };
}
