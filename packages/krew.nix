{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "krew-${version}";
  version = "0.4.2";

  # goPackagePath = "sigs.k8s.io/krew";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-P4b8HMkqxzYKz9OgI4pNCjR9Wakh+kIIAnUAkayzGEo=";
  };

  vendorSha256 = "sha256-FQQCHq9f0yY8vSsvWIR7WKq+0c+dgGEnoQmXtoN6Ep0=";

  subPackages = [ "cmd/krew" ];

  doCheck = false;

  meta = with lib; {
    description = "Krew is the package manager for kubectl plugins";
    homepage = https://github.com/kubernetes-sigs/krew;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
