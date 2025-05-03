{
  pkgs,
  python,
  buildPythonPackage ? python.pkgs.buildPythonPackage,
  fetchPypi ? pkgs.fetchPypi,
  setuptools ? python.pkgs.setuptools,
  wheel ? python.pkgs.wheel,
}:
buildPythonPackage rec {
  pname = "markdown-it-py";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4/YKlPoGbcUux2Zh43yFHLIy2S+YhrFctWCqraLfj+s=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = false;
  build-system = [
    setuptools
    # wheel
  ];
}
