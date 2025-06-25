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
      # url = "github:MarceColl/zen-browser-flake";
      # url = "github:ch4og/zen-browser-flake";
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcmojave-hyprcursor = {
      url = "github:libadoxon/mcmojave-hyprcursor";
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
        { hostname = "desktop"; system = "x86_64-linux"; }
      ];
      nixosConfigurations = import ./utilities/mkNixosConfigurations.nix { inherit inputs hosts users; };
      homeConfigurations = import ./utilities/mkHomeConfigurations.nix { inherit inputs users; };
      # TODO disko
      # diskoConfigurations = import ./utilities/disko.nix { inherit inputs; };
    in
    {
      inherit nixosConfigurations homeConfigurations;

      # inherit diskoConfigurations;
    };
}
