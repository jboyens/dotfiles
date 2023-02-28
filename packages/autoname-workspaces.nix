{ stdenv, lib, fetchFromGitHub, python3 }:

let
  pythonWithPackages = python3.withPackages(p: with p; [
    i3ipc
  ]);
in
stdenv.mkDerivation rec {
  pname = "autoname-workspaces";
  version = "1.8.1";

  src = fetchFromGitHub rec {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "sha256-WxnT+le9vneQLFPz2KoBduOI+zfZPhn1fKlaqbPL6/g=";
  };

  buildInputs = [ pythonWithPackages ];

  installPhase = ''
    mkdir -p $out/bin
    cp contrib/autoname-workspaces.py $out/bin
  '';
}
