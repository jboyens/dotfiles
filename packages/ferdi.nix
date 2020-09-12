{ stdenv, fetchurl, makeWrapper, wrapGAppsHook, autoPatchelfHook, dpkg
, xorg, atk, glib, pango, gdk-pixbuf, cairo, freetype, fontconfig, gtk3
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify, xdg_utils }:

let
  version = "5.6.0-beta.2";
in stdenv.mkDerivation {
  pname = "ferdi";
  inherit version;
  src = fetchurl {
    url = "https://github.com/getferdi/ferdi/releases/download/${version}/ferdi_${version}_amd64.deb";
    sha256 = "0shd7p4v3dkkxzzdyi1zsh60330pxb7m0897lcr2367hr0a0j69s";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper wrapGAppsHook dpkg ];
  buildInputs = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver
  ]) ++ [
    gtk3 atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  ];
  runtimeDependencies = [ udev libnotify ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Ferdi/ferdi $out/bin

    # provide desktop item and icon
    cp -r usr/share $out
    substituteInPlace $out/share/applications/ferdi.desktop \
      --replace /opt/Ferdi/ferdi ferdi
  '';

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/opt/Ferdi/ferdi \
      --prefix PATH : ${xdg_utils}/bin \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with stdenv.lib; {
    description = "A (really) free messaging app that combines chat & messaging services into one application";
    homepage = https://getferdi.com;
    license = licenses.free;
    maintainers = [ maintainers.jboyens ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
