{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-t+8AcbQP9mvffpZ4anZICzAQNTQ+2r74zXlyoL2qEfs=";
  };

  cargoSha256 = "sha256-tey9uL5cXx/vnHmFTU/nmUxKqOOHIWy+GwWSoXqfDPk=";

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
  };
}