{ stdenv, fetchFromGitHub, rustPlatform, pkgs }:

rustPlatform.buildRustPackage rec {
  pname = "wldash";
  version = "20200618";

  src = fetchFromGitHub {
    owner = "kennylevinsen";
    repo = pname;
    rev = "76e9d267df4c64ed4576ff350907e9c803967632";
    sha256 = "1wvly5ysz06fhg8c119lcj5c1qf2qipk7570bivps7z5k0yh94zr";
  };

  # buildInputs = with pkgs; [ pkg-config pulseaudio alsaLib dbus.dev dbus.lib fontconfig.dev fontconfig.lib wlroots wayland ];
  nativeBuildInputs = with pkgs; [ makeWrapper pkgconfig ];
  buildInputs = with pkgs; [ wayland wlroots wayland-protocols alsaLib dbus.dev fontconfig.dev pulseaudio ];

  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ pkgs.wayland pkgs.libxkbcommon ];

  preFixup = ''
    wrapProgram $out/bin/wldash \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}";
  '';

  cargoSha256 = "0nldjcn9hk93908yr01a40aqc3ljj8mfi6x1nwr24fvh6n3h1v6g";

  meta = with stdenv.lib; {
    description = "A dashboard/launcher/control-panel thing for Wayland";
    homepage = https://github.com/kennylevinsen/wldash;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [
      maintainers.jboyens
    ];
  };
}
