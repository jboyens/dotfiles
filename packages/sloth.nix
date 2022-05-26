{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sloth";
  version = "v0.10.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = version;
    sha256 = "sha256-V8qyZlCDhfhVGYPDBVlygLlExO/XbgkS/w7dw6U4gSo=";
  };

  vendorSha256 = "sha256-7U+y31DaWJFCzR8x9pCuwCA4vi89sQdAcDvpXbF9x6Y=";

  subPackages = ["cmd/sloth"];

  doCheck = false;

  meta = with lib; {
    description = "Easy and simple Prometheus SLO generator";

    homepage = https://sloth.dev;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
