{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sources,
}:
buildGoModule rec {
  inherit (sources.tilt) pname src;

  version = lib.removePrefix "v" sources.tilt.version;

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
