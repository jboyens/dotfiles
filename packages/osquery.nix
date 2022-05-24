{ lib, stdenv, fetchurl, makeWrapper, wrapGAppsHook, autoPatchelfHook, dpkg
, zlib }:

let
  version = "5.2.2-1";
in stdenv.mkDerivation {
  pname = "osquery";
  inherit version;
  src = fetchurl {
    url = "https://pkg.osquery.io/deb/osquery_${version}.linux_amd64.deb";
    sha256 = "sha256-nIisQaFYzSJx5rtcQnZUcLLhfq9OUEdDRjW7qsVks5g=";
  };

  # don't remove runtime deps
  # dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper dpkg ];
  buildInputs = [ zlib ];
  # buildInputs = (with xorg; [
  #   libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
  #   libXrender libX11 libXtst libXScrnSaver libxshmfence
  # ]) ++ [
  #   gtk3 atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
  #   gnome2.GConf nss nspr alsaLib cups expat mesa stdenv.cc.cc
  # ];
  # runtimeDependencies = [ udev libnotify ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
  '';

  # dontWrapGApps = true;

  # postFixup = ''
  #   wrapProgram $out/opt/Ferdi/ferdi \
  #     --prefix PATH : ${xdg_utils}/bin \
  #     "''${gappsWrapperArgs[@]}"
  # '';

  meta = with lib; {
    description = "A (really) free messaging app that combines chat & messaging services into one application";
    homepage = https://getferdi.com;
    license = licenses.free;
    maintainers = [ maintainers.jboyens ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
