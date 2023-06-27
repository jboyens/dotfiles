{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  sources,
}:
buildGoModule rec {
  inherit (sources.testkube) pname src;
  version = lib.removePrefix "v" sources.testkube.version;

  vendorSha256 = "sha256-JkJadN4ECvUT9Wvp28pkY+RyxgwV34J77gBJz33wQVM=";

  doCheck = false;
  subPackages = ["cmd/kubectl-testkube"];

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = "https://github.com/kubeshop/testkube/";
    license = licenses.mit;
    maintainers = [maintainers.jboyens];
    platforms = platforms.unix;
  };
}
