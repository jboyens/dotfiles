{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "logcli-${version}";
  version = "1.3.0";

  goPackagePath = "github.com/grafana/loki";
  subPackages = [ "cmd/logcli" ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    sha256 = "0b1dpb3vh5i18467qk8kpb5ic14p4p1dfyr8hjkznf6bs7g8ka1q";
  };

  meta = with stdenv.lib; {
    description = "The command-line interface to Grafana's Loki Logging system";
    homepage = https://github.com/grafana/loki;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
