{ pkgs }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "streamdown";
  version = "0.34.0";

  format = "pyproject";

  src = pkgs.fetchPypi {
    inherit pname version;
    hash = ""; # temporary
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    # rich
    # pygments
    # ...
  ];

  pythonImportsCheck = [ "streamdown" ];

  meta = with pkgs.lib; {
    description = "Streaming Markdown renderer for terminals";
    homepage    = "https://pypi.org/project/streamdown/";
    license     = licenses.mit;
    mainProgram = "sd";
  };
}

