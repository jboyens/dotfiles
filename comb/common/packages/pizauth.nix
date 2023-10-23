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
  cargoLock = {
    lockFileContents = builtins.readFile ./pizauth-Cargo.lock;
  };

  postPatch = ''
    cp ${./pizauth-Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "pizauth is a simple program for requesting, showing, and refreshing OAuth2 access tokens";
    homepage = "https://github.com/ltratt/pizauth";
    license = licenses.mit;
    maintainers = [maintainers.jboyens];
  };
}
