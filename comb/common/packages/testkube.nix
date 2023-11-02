{
  lib,
  buildGoModule,
  sources,
  ...
}:
buildGoModule {
  inherit (sources.testkube) pname src;
  version = lib.removePrefix "v" sources.testkube.version;

  vendorSha256 = "sha256-SvRGtaD7fRCpjeQ3pnCHNtsss7D87FkknFoEuxHG3nE=";
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
