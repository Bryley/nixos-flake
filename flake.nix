{
  description = "Bryley's 2025 NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      inherit ((import ./lib.nix { inherit nixpkgs; })) buildSystem;

      hosts = builtins.listToAttrs [
        buildSystem
        {
          name = "laptop";
          system = "x86_64-linux";
          disk = "nvme0n1";
        }
      ];
    in
    {
      nixosConfigurations = hosts;
    };
}
