{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.7.17";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-tUfeRjZjQWYroiHUKKpEl1PLyujCvu+Ylg1sHHZ5kUg=";
  };

  vendorSha256 = "sha256-tMwH0EgVzu8FzOaNrUmC1noyTQEIjZdGgjPlADpNFRk=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
