{ lib, python3, pkgs }:

python3.pkgs.buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.2.4";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-uEbXXy2/ejbzp1vZj0WXDH3dvk/1q7b9pV9zb9DmY7s=";
  };

  click_7_x = python3.pkgs.buildPythonPackage rec {
    pname = "click";
    version = "7.1.2";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
    };
  };

  pyyaml_5_4 = python3.pkgs.buildPythonPackage rec {
    pname = "PyYAML";
    version = "5.4.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "yaml";
      repo = "pyyaml";
      rev = version;
      sha256 = "1v386gzdvsjg0mgix6v03rd0cgs9dl81qvn3m547849jm8r41dx8";
    };

    nativeBuildInputs = [ python3.pkgs.cython ];

    buildInputs = [ pkgs.libyaml ];

    checkPhase = let
      testdir = if python3.pkgs.pythonOlder "3.6" then "tests/lib" else "tests/lib3";
    in ''
      runHook preCheck
      PYTHONPATH="${testdir}:$PYTHONPATH" ${python3.interpreter} -m test_all
      runHook postCheck
    '';

    pythonImportsCheck = [ "yaml" ];
  };

  nativeBuildInputs = with python3.pkgs; [
    pytestrunner
  ];

  propagatedBuildInputs = with python3.pkgs; [
    i3ipc
    xcffib
    click_7_x
    cffi
    xpybutil
    marshmallow
    pyyaml_5_4
  ];

  # Tests require access to a X session
  doCheck = false;

  pythonImportsCheck = [ "flashfocus" ];

  meta = with lib; {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
