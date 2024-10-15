{
  lib,
  stdenvNoCC,
  fetchzip,
  sources,
}:
stdenvNoCC.mkDerivation rec {
  pname = "pragmasevka";
  version = "1.6.6";

  src = fetchzip {
    url = "https://github.com/shytikov/pragmasevka/releases/download/v${version}/Pragmasevka.zip";
    stripRoot = false;
    hash = "sha256-URgqxl3Hy0AXjPiQyd3AGmue68IYZOC8FoVEodYqwxQ=";
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
