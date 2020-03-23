{ appimageTools, fetchurl, lib, firefox, gsettings-desktop-schemas, gtk3
, makeDesktopItem }:

let
  pname = "pragli";
  version = "2020-03-16";
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Pragli";
    comment = "Desktop chat client for Remote Teams";
    icon = "pragli";
    terminal = "false";
    exec = pname;
    categories = "Network;InstantMessaging;";
  };
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url =
      "https://storage.googleapis.com/always-on-cdf01.appspot.com/dist/Pragli.AppImage";
    sha256 = "fd8cff2ed41107a3a235fe8c0cfea5e7d3a232242658ee9bbfce3e378046555f";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    export BROWSER=firefox
    export XDG_UTILS_DEBUG_LEVEL=30
  '';
  # not necessary, here for debugging purposes
  # adapted from the original runScript of appimageTools
  extracted_source = appimageTools.extractType2 { inherit name src; };
  debugScript = appimageTools.writeScript "run" ''
    #!/usr/bin/env bash

    export APPDIR=${extracted_source}
    export APPIMAGE_SILENT_INSTALL=1

    # >>> inspect the script running environment here <<<
    echo "INSPECT: ''${GIO_EXTRA_MODULES:-no extra modules!}"
    echo "INSPECT: ''${GSETTINGS_SCHEMA_DIR:-no schemas!}"
    echo "INSPECT: ''${XDG_DATA_DIRS:-no data dirs!}"

    cd $APPDIR
    exec ./AppRun "$@"
  '';

  # for debugging purposes only
  runScript = debugScript;

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.firefox ];

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    chmod +x $out/bin/${pname}
    mkdir -p "$out/share/applications/"
    cp "${desktopItem}"/share/applications/* "$out/share/applications/"
    substituteInPlace $out/share/applications/*.desktop --subst-var out
  '';

  meta = with lib; {
    description = "Desktop chat client for Remote Teams";
    homepage = "https://pragli.com";
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jboyens ];
  };
}
