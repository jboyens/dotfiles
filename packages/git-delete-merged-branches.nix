{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c52x2z6fzx8sqcfrdli5i4cxa7i8jyr84dv54q8rnxnjcjmavjq";
  };

  pick = buildPythonPackage rec {
    pname = "pick";
    version = "0.6.7";

    src = fetchPypi {
      pname = "pick";
      version = "0.6.7";
      sha256 = "0cqggkawy1x4ilisav856rfr8hvzcszgqmwkqbwcgy6b4a95l0pf";
    };

    doCheck = false;
  };

  doCheck = false;

  propagatedBuildInputs = [ colorama pick ];

  meta = with lib; {
    description = "";
    homepage = https://github.com/nwg-piotr/autotiling;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [
      maintainers.jboyens
    ];
  };
}
