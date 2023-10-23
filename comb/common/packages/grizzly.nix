{
  stdenv,
  lib,
  buildGo119Module,
  fetchFromGitHub,
  sources,
}:
buildGo119Module rec {
  inherit (sources.grizzly) pname src;

  version = lib.removePrefix "v" sources.grizzly.version;

  vendorSha256 = "sha256-DDYhdRPcD5hfSW9nRmCWpsrVmIEU1sBoVvFz5Begx8w=";

  CGO_ENABLED = 0;

  doCheck = false;

  meta = with lib; {
    description = "A utility for managing various observability resources with Jsonnet";
    homepage = "https://github.com/grafana/grizzly";
    license = licenses.asl20;
    maintainers = [maintainers.jboyens];
    platforms = platforms.unix;
  };
}
