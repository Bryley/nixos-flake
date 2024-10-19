{ pkgs ? import <nixpkgs> { } }:

pkgs.buildNpmPackage rec {
  pname = "vtsls";
  version = "0.2.6";

  # src = pkgs.fetchFromGitHub {
  #   owner = "yioneko";
  #   repo = "vtsls";
  #   rev = "service-v${version}";
  #   sha256 = "sha256-qaI2inIxpvFGcTivMWYyUL0Mo/byt6G8ZDyU21zxSLc=";
  # };

  src = pkgs.fetchgit {
    url = "https://github.com/yioneko/vtsls.git";
    rev = "server-v${version}";
    sha256 = "sha256-HCi9WLh4IEfhgkQNUVk6IGkQfYagg805Rix78zG6xt0=";
    fetchSubmodules = true;
  };

  nativeBuildImports = [ pkgs.pnpm ];

  # Post-patch step to generate package-lock.json
  postPatch = ''
    cp ${./package.json} ./package.json
    cp ${./packages/service/package.json} ./packages/service/package.json
    cp ${./package-lock.json} ./package-lock.json
  '';

  makeCacheWritable = true;
  npmWorkspace = "packages/server";
  npmDepsHash = "sha256-MhWJ2k/WsQX7YidnrwGbzi87tNwOzyqTrxJvcugU3kQ=";

  # buildInputs = [
  #   pkgs.nodejs
  #   pkgs.pnpm
  #   pkgs.node2nix
  # ];

  # buildPhase = ''
  #   pnpm build
  # '';

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';

  meta = with pkgs.lib; {
    description = "A TypeScript language server written in TypeScript";
    homepage = "https://github.com/yioneko/vtsls";
    license = licenses.mit;
    maintainers = [ ];
  };
}
