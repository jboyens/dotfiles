{
  lib,
  rustPlatform,
  sources,
  ...
}:
rustPlatform.buildRustPackage {
  inherit (sources.pizauth) src;

  name = sources.pizauth.pname;
  version = lib.removePrefix "v" sources.pizauth.version;

  # cargoSha256 = "sha256-DbWLNgr60vTbrcBRcJGRm+bLGNjhaXLizUuaeOPU5Rc=";
  cargoLock = sources.pizauth.cargoLock."Cargo.lock";

  # postPatch = ''
  #   cp ${./pizauth-Cargo.lock} Cargo.lock
  # '';

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
