{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-OMNJNnRfFQ/6mhOkPLkyfrh2lobolDrkjpGQWnsfRps=";
  };

  cargoSha256 = "sha256-gaOag1fv11tZ4ySV1+7ymS2s+Jk0lXJ0YHAYRa78h7g=";

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [maintainers.jboyens];
  };
}
