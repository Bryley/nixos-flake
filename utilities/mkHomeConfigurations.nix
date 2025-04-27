# Returns a list of home-manager setups
# Example:
# [ { bryley = inputs.home-manager.lib.homeManagerConfiguration {...} } ]
#
{ inputs, users }:
let

  systemUser =
    user:
    builtins.map (system: userField user system) [
      "aarch64-linux"
      "x86_64-linux"
    ];

  userField = user: system: {
    name = "${user.name}-${system}";
    value = mkHome user system;
  };

  mkHome =
    user: system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs;
        inherit (user) fullName email;
        username = user.name;
      };
      modules = [ ../homes/${user.name} ];
    };
in
builtins.listToAttrs (inputs.nixpkgs.lib.flatten (builtins.map systemUser users))
