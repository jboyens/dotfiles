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
  version = "0.71";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "sov";
    rev = version;
    sha256 = "sha256-6FdZ3UToeIAARxrOqSWBX+ALrlr4s2J0bj9c3l9ZTyQ=";
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