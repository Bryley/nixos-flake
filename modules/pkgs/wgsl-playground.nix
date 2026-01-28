{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "wgsl-playground";
  version = "0.1.8";

  src = pkgs.lib.fetchFromGitHub {
    owner = "paulgb";
    repo = "wgsl-playground";
  };

  # TODO maybe this in the future to get it working

}
