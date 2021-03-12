{ stdenv, fetchFromGitHub, wl-clipboard }:

let
  pname = "wl-clipboard-x11";
  version = "5";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "brunelli";
    repo = "wl-clipboard-x11";
    rev = "v${version}";
    sha256 = "i+oF1Mu72O5WPTWzqsvo4l2CERWWp4Jq/U0DffPZ8vg=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  propagatedBuildInputs = [ wl-clipboard ];

  installFlags = [ "DESTDIR=$(out)" ];
  installTargets = [ "install.core" ];

  postFixup = ''
	ln -sf "$out/usr/share/man/man1/wl-clipboard-x11.1" "$out/usr/share/man/man1/xclip.1"
	ln -sf "$out/usr/share/man/man1/wl-clipboard-x11.1" "$out/usr/share/man/man1/xsel.1"
    mkdir $out/bin
	ln -sf "$out/usr/share/wl-clipboard-x11/wl-clipboard-x11" "$out/bin/xclip"
	ln -sf "$out/usr/share/wl-clipboard-x11/wl-clipboard-x11" "$out/bin/xsel"
  '';

  meta = with stdenv.lib; {
    description = "A wrapper to use wl-clipboard as a drop-in replacement to X11 clipboard tools";
    homepage    = "https://github.com/brunelli/wl-clipboard-x11";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ jboyens ];
  };
}
