{ stdenv, fetchurl, makeWrapper, wrapGAppsHook, autoPatchelfHook, dpkg, xorg
, atk, glib, pango, gdk-pixbuf, cairo, freetype, fontconfig, gtk3, gnome2, dbus
, nss, nspr, alsaLib, cups, expat, udev, libnotify, xdg_utils }:

stdenv.mkDerivation rec {
  pname = "fraidycat";
  version = "1.1.6";

  src = fetchurl {
    url =
      "https://github.com/kickscondor/fraidycat/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "0cnpw7zwgnlnajgmi8kyam222rfg3k31v5d06f1xgdkflf18w81g";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapGAppsHook dpkg ];
  buildInputs = (with xorg; [
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libX11
    libXtst
    libXScrnSaver
  ]) ++ [
    gtk3
    atk
    glib
    pango
    gdk-pixbuf
    cairo
    freetype
    fontconfig
    dbus
    gnome2.GConf
    nss
    nspr
    alsaLib
    cups
    expat
    stdenv.cc.cc
  ];
  runtimeDependencies = [ udev libnotify ];

  # don't remove runtime deps
  dontPatchELF = true;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Fraidycat/fraidycat $out/bin

    chmod 4755 $out/opt/Fraidycat/chrome-sandbox || true

    # provide desktop item and icon
    cp -r usr/share $out
    substituteInPlace $out/share/applications/fraidycat.desktop \
      --replace /opt/Fraidycat/fraidycat fraidycat
  '';

  dontWrapGApps = true;

  meta = with stdenv.lib; {
    description =
      "A (really) free messaging app that combines chat & messaging services into one application";
    homepage = "https://getferdi.com";
    license = licenses.free;
    maintainers = [ maintainers.jboyens ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
