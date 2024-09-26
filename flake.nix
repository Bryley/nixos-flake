{
  description = "Bryley's 2024 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      users = [
        { name = "bryley"; fullName = "Bryley Hayter"; email = "bryleyhayter@gmail.com"; }
      ];
      hosts = [
        { hostname = "laptop"; system = "x86_64-linux"; }
      ];
      nixosConfigurations = import ./utilities/mkNixosConfigurations.nix { inherit inputs hosts users; };
      homeConfigurations = import ./utilities/mkHomeConfigurations.nix { inherit inputs users; };
      # TODO disko
      # diskoConfigurations = import ./utilities/disko.nix { inherit inputs; };
    in
    {
      inherit nixosConfigurations;
      inherit homeConfigurations;

      # inherit diskoConfigurations;
    };
}
