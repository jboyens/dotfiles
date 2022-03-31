{ stdenv, lib, fetchurl, appimageTools }:

let
  pname = "bitwarden";
  version = "1.32.0";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v${version}/Bitwarden-${version}-x86_64.AppImage";
    sha256 = "02g0g5m84qh3cg743npsnfiidfvxp286kjj74r6d079xvp7v5kya";
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
