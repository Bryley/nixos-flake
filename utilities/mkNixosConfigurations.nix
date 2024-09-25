# Returns nixosConfigurations set to use based on hosts
{ inputs, hosts, users }:
let
  mkSystem = host:
    {
      name = host.hostname;
      value = inputs.nixpkgs.lib.nixosSystem {
        system = host.system;
        specialArgs = { inherit inputs; hostname = host.hostname; inherit users; };
        modules = [
          ../hosts/${host.hostname}/configuration.nix
          ../modules
        ];
      };
    };
in
builtins.listToAttrs (builtins.map mkSystem hosts) 
