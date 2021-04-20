{ stdenv, lib, fetchurl, appimageTools }:

let
  pname = "bitwarden";
  version = "1.25.0";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v1.25.0/Bitwarden-1.25.0-x86_64.AppImage";
    sha256 = "1549eb9136393c9593d84f782874604fa4af7fc344d484a5483bcda186de5a8d";
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
