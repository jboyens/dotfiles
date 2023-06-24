{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sources,
}:
rustPlatform.buildRustPackage rec {
  inherit (sources.pizauth) src pname;

  version = lib.removePrefix "v" sources.pizauth.version;

  # cargoSha256 = "sha256-J4kdvAB1CvibrYaFnzx1oBPYYG7XbCuGXx6CUThOCYw=";
  cargoLock = sources.pizauth.cargoLock."Cargo.lock";

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [maintainers.jboyens];
  };
}
