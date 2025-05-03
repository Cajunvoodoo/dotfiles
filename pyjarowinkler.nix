{
  pkgs,
  python,
  buildPythonPackage ? python.pkgs.buildPythonPackage,
  fetchPypi ? pkgs.fetchPypi,
  setuptools ? python.pkgs.setuptools,
  wheel ? python.pkgs.wheel,
}:
buildPythonPackage rec {
  pname = "pyjarowinkler";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SYKINO3a5qB47hMp3KVyVBGSo/SeQHYI9AY8aSwe8d8=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    # wheel
  ];
}
