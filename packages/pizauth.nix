{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-jqfK926KrWevsP+Yif3PdMIZWeIIQaA5jP14acZehwc=";
  };

  cargoSha256 = "sha256-J4kdvAB1CvibrYaFnzx1oBPYYG7XbCuGXx6CUThOCYw=";

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [maintainers.jboyens];
  };
}
