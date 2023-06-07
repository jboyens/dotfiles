{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wrapGAppsHook,
  vala,
  pkg-config,
  glib,
  json-glib,
  libhandy,
  gtk-layer-shell,
  libgee,
  libpulseaudio,
  scdoc,
  bash-completion,
  cairo,
  gtk3,
  gobject-introspection,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "sway-notification-center";
  version = "2023-05-07";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = "310024964c5fb09bc87df5dcdb16b19159568ebd";
    hash = "sha256-FfektgOE0PJUjjulnYnNGDHcKdT2hQBfvHB6MBiSNfY=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    vala
    wrapGAppsHook
    pkg-config
    scdoc
    bash-completion
    python3
  ];

  buildInputs = [
    cairo
    glib
    json-glib
    libhandy
    gtk-layer-shell
    libgee
    libpulseaudio
    gtk3
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py

    substituteInPlace src/functions.vala --replace /usr/local/etc $out/etc
  '';

  postInstall = ''
    substituteInPlace $out/etc/xdg/swaync/style.css --replace /etc $out/etc
    substituteInPlace $out/etc/xdg/swaync/config.json --replace /etc $out/etc
    substituteInPlace $out/etc/xdg/swaync/configSchema.json --replace /etc $out/etc
  '';

  meta = with lib; {
    description = "A simple GTK based notification daemon for SwayWM";
    homepage = "https://github.com/ErikReider/SwayNotificationCenter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
  };
}
