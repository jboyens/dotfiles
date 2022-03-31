{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "krew-${version}";
  version = "0.4.3";

  # goPackagePath = "sigs.k8s.io/krew";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-aW9yASskwDt+5Lvsdju9ZR/HeZ4x8heWljdhqK0ZTx8=";
  };

  vendorSha256 = "sha256-VXGjKzkOpaxyJClwXbxg15xmGdFi6arH8f4nN5/1SA4=";

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
