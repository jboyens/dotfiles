{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.10.13";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-r3065HJmP2H66cPZSfqPGXGk/zpsN+cEkWRV33iM0Q0=";
  };

  vendorSha256 = "sha256-PyRLLavP67v9c/p6ljkfFAYFW7pqC5jQXJNt+cxBDW4=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
