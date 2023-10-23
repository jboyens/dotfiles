{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  sources,
}:
buildGoModule rec {
  inherit (sources.sloth) src pname;

  version = lib.removePrefix "v" sources.sloth.version;

  vendorSha256 = "sha256-j6qXUQ/Tu3VNQL5xBOHloRn5DH3KG/znCLi1s8RIoL8=";

  subPackages = ["cmd/sloth"];

  doCheck = false;

  meta = with lib; {
    description = "Easy and simple Prometheus SLO generator";

    homepage = "https://sloth.dev";
    license = licenses.asl20;
    maintainers = [maintainers.jboyens];
    platforms = platforms.unix;
  };
}
