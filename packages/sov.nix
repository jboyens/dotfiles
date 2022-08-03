{ lib, stdenv, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-protocols
, wayland-scanner
, wayland
, cmake
, freetype
}:

stdenv.mkDerivation rec {
  pname = "sov";
  version = "0.72";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "sov";
    rev = version;
    sha256 = "sha256-av+st0tux+ho8bfJwx6Nk1pma1Pjvv/dpW5BWnUDNvQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-protocols
    wayland-scanner
    cmake
    freetype
  ];

  buildInputs = [
    wayland
  ];
}