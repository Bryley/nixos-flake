# TODO: This code doesn't work so remove or fix :(
# This code was copied from https://github.com/NixOS/nixpkgs/pull/319501
# TODO: Replace this when PR gets merged
{ pkgs ? import <nixpkgs> { } }:
pkgs.buildNpmPackage rec {
  pname = "vtsls";
  version = "0.2.3";

  src = pkgs.fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    rev = "server-v${version}";
    hash = "sha256-rHiH42WpKR1nZjsW+Q4pit1aLbNIKxpYSy7sjPS0WGc=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/packages/server";

  npmDeps = pkgs.importNpmLock {
    npmRoot = "${src}/packages/server";
    packageLock = pkgs.lib.importJSON ./package-lock.json;
  };

  npmDepsHash = "sha256-R70+8vwcZHlT9J5MMCw3rjUQmki4/IoRYHO45CC8TiI=";

  inherit (pkgs.importNpmLock) npmConfigHook;

  dontNpmPrune = true;

  meta = with pkgs.lib; {
    description = "LSP wrapper around TypeScript extension bundled with VSCode.";
    homepage = "https://github.com/yioneko/vtsls";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
