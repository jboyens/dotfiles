{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-vZlhe82sNnH481y6uhrrGtdT3SAhrkIztqL0v1dzXvI=";
  };

  cargoSha256 = "sha256-4aNnnlBVvStPt1Ki7lbHtn49dTqarMU/Oh8Ryq6ogF8=";

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
  };
}