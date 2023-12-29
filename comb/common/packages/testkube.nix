{
  lib,
  buildGoModule,
  sources,
  ...
}:
buildGoModule {
  inherit (sources.testkube) pname src;
  version = lib.removePrefix "v" sources.testkube.version;

  vendorHash = "sha256-09OYhF1Vs8mK9yQkaUSynqx9GYHcHla/ICEtQIuGxxo=";
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
