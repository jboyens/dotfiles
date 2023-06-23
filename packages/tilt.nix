{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tilt";
  /*
   Do not use "dev" as a version. If you do, Tilt will consider itself
  running in development environment and try to serve assets from the
  source tree, which is not there once build completes.
  */
  version = "0.32.3";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "tilt";
    rev = "v${version}";
    hash = "sha256-5QTZUapHhSSI+UZu77IUZdflCIm+oCu4kPQVhLHCsUQ=";
  };

  vendorHash = null;

  ldflags = ["-s" "-w" "-X main.version=${version}"];

  subPackages = ["cmd/tilt"];

  doCheck = false;

  meta = with lib; {
    description = "Define your dev environment as code. For microservice apps on Kubernetes";
    homepage = "https://github.com/tilt-dev/tilt";
    license = licenses.asl20;
    maintainers = with maintainers; [anton-dessiatov];
  };
}
