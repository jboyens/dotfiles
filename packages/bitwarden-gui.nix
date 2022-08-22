{ stdenv, lib, fetchurl, appimageTools }:

let
  pname = "bitwarden";
  version = "2022.8.1";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v${version}/Bitwarden-${version}-x86_64.AppImage";
    sha256 = lib.fakeHash;
  };

  extraPkgs = pkgs: with pkgs; [ libsecret ];

  meta = with lib; {
    description = "Bitwarden Desktop app";
    homepage    = "https://github.com/bitwarden/desktop";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ jboyens ];
  };
}
