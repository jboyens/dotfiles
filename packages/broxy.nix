{ stdenv, pkgs, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "broxy";
  version = "1.0.0-alpha.3";

  goPackagePath = "github.com/rhaidiz/broxy";

  src = fetchFromGitHub {
    owner = "rhaidiz";
    repo = "broxy";
    rev = "v${version}";
    sha256 = "175zyivzma7yaygqbmxz3lnvyl074k2yp387k2kpv46b2hwwj8y1";
  };

  modSha256 = "00bszgwks3a9vn5h00h0yvyfrcvaak0pfn2gls6xz2g09f1g9b1m";

  propagatedBuildInputs = with pkgs; [ qt5.full ];

  preBuild = ''
    export QT_DIR=${pkgs.qt5.full}
    export QT_DYNAMIC_SETUP=true
  '';

  meta = with stdenv.lib; {
    description = "Broxy is an open source intercept proxy written in Go";
    homepage = https://github.com/rhaidiz/broxy;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jboyens ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
