{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.9.18";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-veKSPPkbi6ZT/henbEA/yLDaP7m41WhF9nT/TQDxh9M=";
  };

  vendorSha256 = "sha256-bDqEjqMLSWccfh+e8HZfYYuR5P4DMifnz0Qnn6PRaNg=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
