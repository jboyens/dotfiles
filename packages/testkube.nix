{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-bUW74Mv54ynhx5RYrvUHk3ft2UXe6zvoiC1+Vrj2FIE=";
  };

  vendorSha256 = "sha256-JkJadN4ECvUT9Wvp28pkY+RyxgwV34J77gBJz33wQVM=";

  doCheck = false;
  subPackages = ["cmd/kubectl-testkube"];

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [maintainers.jboyens];
    platforms = platforms.unix;
  };
}
