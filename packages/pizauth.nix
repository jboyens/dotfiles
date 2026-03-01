{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "pizauth";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "pizauth-1.0.10";
    fetchSubmodules = false;
    sha256 = "sha256-wdR/7gV/2U+MsncbQ6Gy2na5YuBp4F2H8ohij+Dfvcs=";
  };

  cargoHash = "sha256-AvUaeevnV5fIeEKXQAY1IGHcV3l3lTwFmFKsaEPbr+4=";

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
