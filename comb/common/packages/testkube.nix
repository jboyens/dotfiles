{
  lib,
  buildGoModule,
  sources,
  ...
}:
buildGoModule {
  inherit (sources.testkube) pname src;
  version = lib.removePrefix "v" sources.testkube.version;

  vendorSha256 = "sha256-gHW70sUddlq9Y+D/E5YshTMONgxS7TYSr+Se/XsBJXc=";
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
