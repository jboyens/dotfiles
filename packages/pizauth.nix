{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "pizauth";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "pizauth-1.0.7";
    fetchSubmodules = false;
    sha256 = "sha256-lvG50Ej0ius4gHEsyMKOXLD20700mc4iWJxHK5DvYJc=";
  };

  cargoHash = "sha256-WyQIk74AKfsv0noafCGMRS6o+Lq6CeP99AFSdYq+QHg=";

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
