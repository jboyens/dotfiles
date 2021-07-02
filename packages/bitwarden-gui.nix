{ stdenv, lib, fetchurl, appimageTools }:

let
  pname = "bitwarden";
  version = "1.26.5";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v1.26.5/Bitwarden-1.26.5-x86_64.AppImage";
    sha256 = "1864mhk4b449xa7n9lwqnyp00cvxaib9xx4jr037yrffvng3syzw";
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
