{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "autotiling";
  version = "0.9-sway14";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "5370c92d4b86e327210337abe2fdbdc95957b92d";
    sha256 = "05gbdk7b5yr80j48rpgj2kcvvyrvvb51lqbzkhmbzhd8sf010508";
  };

  dontBuild = true;
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [ i3ipc ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -a autotiling.py $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatically switches splith / splitv on i3 and sway based on the window dimensions";
    homepage = https://github.com/nwg-piotr/autotiling;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [
      maintainers.jboyens
    ];
  };
}
