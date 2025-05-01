{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "pragmasevka";
  version = "1.7.0";

  src = fetchzip {
    url = "https://github.com/shytikov/pragmasevka/releases/download/v${version}/Pragmasevka.zip";
    stripRoot = false;
    hash = "sha256-tTzQVFyVHVeuMknly77YqzWlvLNYtgrpIoJN1sBEcJ0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "PragmataPro meets Iosevka";
    homepage = "https://github.com/shytikov/pragmasevka";
    license = licenses.ofl;
    maintainers = [];
    platforms = platforms.all;
  };
}
