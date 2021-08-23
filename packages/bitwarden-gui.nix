{ stdenv, lib, fetchurl, appimageTools }:

let
  pname = "bitwarden";
  version = "1.27.1";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/bitwarden/desktop/releases/download/v${version}/Bitwarden-${version}-x86_64.AppImage";
    sha256 = "c34suEJXFYF712FbN9cKHdWr+UYrfbt3b04UkDgFMTg=";
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
