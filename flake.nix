{
  description = "Bryley's 2025 NixOS Configuration";

  inputs = {
    # meta = {
    #   url = "path:./meta.toml";
    #   flake = false;
    # };
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
      # meta = builtins.fromTOML (builtins.readFile inputs.meta);
      meta = builtins.fromTOML (builtins.readFile ./meta.toml);

      inherit ((import ./lib.nix { inherit inputs; inherit meta; })) buildSystem;

      hosts = builtins.listToAttrs (builtins.map buildSystem meta.hosts);

      # hosts = builtins.listToAttrs [
      #   buildSystem
      #   {
      #     name = "laptop";
      #     system = "x86_64-linux";
      #     disk = "nvme0n1";
      #   }
      # ];

    in
    {
      nixosConfigurations = hosts;
    };
}
