{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "1.11.22";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-9ohm2ILZE5Q3xIzAVxQBSHQtP0zjc8ZlcW9xsDF4Zuk=";
  };

  vendorSha256 = "sha256-0lTfohJHakZynWgXqevZnyppkZ2Th6PLq+7DITHZXP8=";

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
