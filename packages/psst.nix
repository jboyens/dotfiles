{ lib, rustPlatform, fetchFromGitHub, wrapGAppsHook, pkg-config, dbus, gtk3, cairo }:

rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "e6e3cfafa547ea188e23145b501e669f62558bf4";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = version;
    sha256 = "1Cd9Vs+H/hzCfAI18JEyPcKjeVhCXkCikcPzHmYiytM=";
  };

  cargoSha256 = "I0vF2CVPB8yTVYZNNmiC5X9ePf3bZ8fhMbMXECBaes4=";

  nativeBuildInputs = [
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    cairo
    gtk3
    dbus
  ];

  meta = with lib; {
    description = "Fast Spotify client with native GUI, without Electron, built in Rust.";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
  };
}