{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "krew-${version}";
  version = "0.4.0";

  # goPackagePath = "sigs.k8s.io/krew";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
    sha256 = "m9aIibivbNpLDu2HSoWQ0nOnvQFfLDOYSUDXZW+8i7k=";
  };

  vendorSha256 = "9g1WiBaNDOEhfMGM+iQptfNcAmV3fp1gaktlq8uWuq4=";

  subPackages = [ "cmd/krew" ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Krew is the package manager for kubectl plugins";
    homepage = https://github.com/kubernetes-sigs/krew;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
