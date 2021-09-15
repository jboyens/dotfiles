{ lib, pkgs, fetchFromGitHub, wrapGAppsHook, pkg-config, dbus, gtk3, cairo }:

let
  mkRustPlatform = pkgs.callPackage ./mk-rust-platform.nix {};
    rustPlatform = mkRustPlatform {
      channel = "stable";
    };
in rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "37b1cce64aa079189f36857dd991e2e998e8bec1";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = version;
    sha256 = "sha256-wDJsf+xAraRDnc3uBrK3E0/2N/X63Wjvzto42MynFww=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-YKfAOSXkxQxn+eld4ZFMn5W42wrdWoEi2pvYW947cNo=";

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