{ pkgs }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "streamdown";
  version = "0.34.0";

  format = "pyproject";

  src = pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-SVn8/rJDbms3OkhBCPmCu1K+HVyNFIX7xgVVmjmsJdA=";
  };

  nativeBuildInputs = with pkgs.python3Packages; [
    hatchling
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    appdirs
    pygments
    pylatexenc
    term-image
    toml
    wcwidth
  ];

  pythonImportsCheck = [ "streamdown" ];

  meta = with pkgs.lib; {
    description = "Streaming Markdown renderer for terminals";
    homepage = "https://pypi.org/project/streamdown/";
    license = licenses.mit;
    mainProgram = "sd";
  };
}
