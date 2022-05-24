{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet";
  version = "0.18.0";
  rev = "2f2f6d664f06d064c4b3525ea34a789c1ac95cda";

  src = fetchFromGitHub {
    inherit rev;

    owner = "google";
    repo = "go-jsonnet";
    sha256 = "sha256-EsHPgAJg3rkSymBJbdL3KizPKWIgDUGeLry0nxujgYw=";
  };

  vendorSha256 = "sha256-fZBhlZrLcC4xj5uvb862lBOczGnJa9CceS3D8lUhBQo=";

  doCheck = false;

  subPackages = [ "cmd/jsonnet" "cmd/jsonnetfmt" "cmd/jsonnet-deps" ];

  meta = with lib; {
    description = "go-jsonnet";
    homepage = "https://github.com/google/jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ jboyens ];
  };
}
