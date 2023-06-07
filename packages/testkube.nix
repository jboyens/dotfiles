{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-vmZpI0mywgBghRKHb7ABX0APbRzjTUt0DeArG7b7TJY=";
  };

  vendorSha256 = "sha256-68I6tm3OYDxP7yunKXLq7bcXhYH10qCbizMpiVfTpYE=";

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
