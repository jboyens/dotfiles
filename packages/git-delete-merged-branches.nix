{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4nwu2X3Ydhvhwn2fU5K9gWjIz6YuurN82edf8bdLo3Y=";
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

  propagatedBuildInputs = [ colorama pick clintermission ];

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
