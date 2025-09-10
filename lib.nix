{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  buildSystem =
    {
      name,
      system,
      disk,
    }:
    {
      inherit name;
      value = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit name disk inputs;
        };
        modules = [
          ./modules/disko.nix
          ./hosts/${name}/configuration.nix
        ];
      };
    };
}
