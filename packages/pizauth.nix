{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "pizauth";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "pizauth-1.0.9";
    fetchSubmodules = false;
    sha256 = "sha256-RrmRdJOYvQ9/DaNXH8fQ3BCNdYba/6HcsT3EAV1qoNA=";
  };

  cargoHash = "sha256-ZY1BcunsR4i8QomRrh9yKdH7CP84Wl7UGUZQ8LUCd68=";

  postInstall = ''
    install -Dm644 $src/pizauth.1 -t $out/share/man/man1
    install -Dm644 $src/pizauth.conf.5 -t $out/share/man/man5
  '';

  meta = with lib; {
    description = "A simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [];
  };
}
