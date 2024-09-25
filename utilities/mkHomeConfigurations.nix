# Returns a list of home-manager setups
# Example:
# [ { bryley = inputs.home-manager.lib.homeManagerConfiguration {...} } ]
# 
{ inputs, users }:
let

  systemUser = user:
    builtins.map (system: userField user system) ["aarch64-linux" "x86_64-linux"];

  userField = user: system:
    { name = user.name; value = (mkHome user system); };

  mkHome = user: system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs;
        username=user.name;
        fullName = user.fullName;
        email = user.email;
      };
      modules = [../homes/${user.name}];
    };
in
builtins.listToAttrs
  (inputs.nixpkgs.lib.flatten (builtins.map systemUser users))

# builtins.listToAttrs (
# inputs.nixpkgs.lib.lists.flatten inputs.flake-utils.lib.eachDefaultSystem (system:
#   builtins.map (user: userField user system) users
# ))


# [ {bryley = inputs.home-manager.lib.homeManagerConfiguration {...}} ]



# let
#   mkHome = { system, name, fullName, email }:
#     inputs.home-manager.lib.homeManagerConfiguration {
#       pkgs = inputs.nixpkgs.legacyPackages.${system};
#       extraSpecialArgs = { inherit inputs; username=name; inherit fullName; inherit email; };
#       modules = [../homes/${name}];
#     };
# in
# builtins.listToAttrs
#   builtins.map (user: { name = user.name; value = mkHome user; }) users

# builtins.map (user: builtins.listToAttrs [
#   { name = user; value = ; }
# ]) users

# { system, name, fullName, email }:
# inputs.home-manager.lib.homeManagerConfiguration {
#   pkgs = inputs.nixpkgs.legacyPackages.${system};
#   extraSpecialArgs = { inherit inputs; username=name; inherit fullName; inherit email; };
#   modules = [../homes/${name}];
# }
