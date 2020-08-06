{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "logcli-${version}";
  version = "1.5.0";

  goPackagePath = "github.com/grafana/loki";
  subPackages = [ "cmd/logcli" ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    sha256 = "137lnd69p8qfg2z8l32dr1mrk2lhrxjx392xfij11sy5i9blfc3n";
  };

  meta = with stdenv.lib; {
    description = "The command-line interface to Grafana's Loki Logging system";
    homepage = https://github.com/grafana/loki;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
