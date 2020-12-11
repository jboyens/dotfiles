{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig
, wayland, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa_noglu
, libglvnd
, libpng, ffmpeg_4
}:

let
  pname = "wlroots_back";
  version = "154fe8696f40151dae999cfc69299aef5132dd14";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "wlroots";
    rev = "154fe8696f40151dae999cfc69299aef5132dd14";
    sha256 = "pW+U8zfxBYLMAgNz9SgtrICEfkbt5K1S4cBJ0wmyTmA=";
  };

  # $out for the library, $bin for rootston, and $examples for the example
  # programs (in examples) AND rootston
  outputs = [ "out" "examples" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa_noglu
    libpng ffmpeg_4
    libglvnd
  ];

  mesonFlags = [
    "-Dlibcap=enabled" "-Dlogind-provider=systemd" "-Dxwayland=enabled" "-Dx11-backend=enabled"
    "-Dxcb-icccm=enabled" "-Dxcb-xkb=enabled" "-Dxcb-errors=enabled"
    "-Dlibseat=disabled"
  ];

  postInstall = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  meta = with stdenv.lib; {
    description = "A modular Wayland compositor library";
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
