{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  dpkg,
  autoPatchelfHook,
  gtk3,
  libz,
  webkitgtk_4_1,
  libayatana-appindicator,
  openssl,
  glib-networking,
  wrapGAppsHook3,
  writeScript,
}:
stdenv.mkDerivation rec {
  pname = "moment-staging";
  version = "0.3.572-staging+791";

  src = fetchurl {
    url = "https://d1zyf2h5975v9k.cloudfront.net/tauri/linux/%5Bstaging%5D+Moment_${lib.escapeURL version}_amd64.deb";
    sha256 = "sha256-GU8YtFp6COv2XO1PJGvGjYg96mtHbG+I6iUXHbTDVgc=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libz
    webkitgtk_4_1
    libayatana-appindicator
    openssl
    glib-networking
  ];

  dontBuild = true;

  unpackPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mv $out/usr/share $out
    mv $out/usr/lib $out
    mv $out/usr/bin $out
    rmdir $out/usr
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules/"
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libayatana-appindicator]}
    )
  '';

  passthru.updateScript = writeScript "update-moment-staging" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre2 common-updater-scripts

    set -eu -o pipefail

    version="$(curl https://d1zyf2h5975v9k.cloudfront.net/tauri/latest-version)"
    update-source-version moment-staging "$version"
  '';

  meta = with lib; {
    description = "Cool";
    homepage = "https://moment.dev";
    downloadPage = "https://github.com/moment-eng/moment/releases";
    changelog = "https://github.com/moment-eng/moment/releases/tag/v${version}";
    # maintainers = with maintainers; [ jboyens ];
    mainProgram = "moment-tauri-app";
    platforms = platforms.all;
  };
}
