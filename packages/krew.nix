{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "krew-${version}";
  version = "0.4.1";

  # goPackagePath = "sigs.k8s.io/krew";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "sha256-+YwBkXrj5sWlMA01GfBhu12st+es5YygkD16jc+blt8=";
  };

  vendorSha256 = "sha256-49kWaU5dYqd86DvHi3mh5jYUQVmFlI8zsWtAFseYriE=";

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
