{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "logcli-${version}";
  version = "1.6.1";

  goPackagePath = "github.com/grafana/loki";
  subPackages = [ "cmd/logcli" ];

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    sha256 = "0bakskzizazc5cd6km3n6facc5val5567zinnxg3yjy29xdi64ww";
  };

  meta = with stdenv.lib; {
    description = "The command-line interface to Grafana's Loki Logging system";
    homepage = https://github.com/grafana/loki;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
