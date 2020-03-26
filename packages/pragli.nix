{ appimageTools, stdenv, fetchurl, lib, firefox, gsettings-desktop-schemas, gtk3
, makeDesktopItem }:

let
  pname = "pragli";
  version = "2020-03-22";
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
    url = "https://storage.googleapis.com/always-on-cdf01.appspot.com/dist/Pragli.AppImage";
    sha256 = "0yclg5pxf2nqkfaxr9xddywhrga37g7zqv4jj2bdqzdwr6nszd46";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  # multiPkgs = null; # no 32bit needed
  # extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.firefox p.xdg_utils p.dbus_tools ];

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
