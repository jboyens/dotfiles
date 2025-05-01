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
  pname = "moment";
  version = "0.3.548+543";

  src = fetchurl {
    url = "https://d324d25svypnd9.cloudfront.net/tauri/linux/Moment_${lib.escapeURL version}_amd64.deb";
    sha256 = "sha256-1h5UoszEBRYqP9vIqFkene7/4zW3gXEawvg0VwwAoZ8=";
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

  passthru.updateScript = writeScript "update-moment" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre2 common-updater-scripts

    set -eu -o pipefail

    version="$(curl https://d324d25svypnd9.cloudfront.net/tauri/latest-version)"
    update-source-version moment "$version"
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
