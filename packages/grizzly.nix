{ stdenv, lib, buildGo119Module, fetchFromGitHub }:

buildGo119Module rec {
  pname = "grizzly";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grizzly";
    rev = "v${version}";
    sha256 = "sha256-FqbgIF/6i00kZIIQni3UjyeK6M8xAFHH6s0AcTgdigc=";
  };

  vendorSha256 = "sha256-OV6biQpxj+fZcM8RyPr7SAjtk4Iseymxb7bJeCnSwmk=";

  CGO_ENABLED = 0;

  doCheck = false;

  meta = with lib; {
    description = "A utility for managing various observability resources with Jsonnet";
    homepage = https://github.com/grafana/grizzly;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
