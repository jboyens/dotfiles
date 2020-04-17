{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "3mux";
  version = "20200411";

  goPackagePath = "github.com/aaronjanse/3mux";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "7ba8725f4d83b9e989a397dec10e535bf97106a5";
    sha256 = "0njx30jxak2x2ba2asbwadx456vgl6ah4kcyxz2zz9kk37sq1v6y";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Terminal multiplexer inspired by i3";
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
