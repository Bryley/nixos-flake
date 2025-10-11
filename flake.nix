{
  description = "Bryley's 2025 NixOS Configuration";

  # TODO NTS: Just finished testing dotfile setups, now it is time to test the
  # local installation on the VM from scratch to see how it goes and clean up
  # the code a bit by removing old code and random comments. Then we can try to
  # switch the installation on the current computer :/ hopefully that goes well
  # ALso setup automatic wallpaper

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
    inputs:
    let
      meta = builtins.fromTOML (builtins.readFile ./meta.toml);

      inherit
        (
          (import ./lib.nix {
            inherit inputs;
            inherit meta;
          })
        )
        buildSystem
        ;

      hosts = builtins.listToAttrs (builtins.map buildSystem meta.hosts);
    in
    {
      nixosConfigurations = hosts;
    };
}
