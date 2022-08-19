{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.4.24";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-BUmq1OqE/8bXQ/9Z2hVmBiET2h/N7T5F6oSrxwRC+/g=";
  };

  vendorSha256 = "sha256-0+S/Y7bTS5CU4MiMOMK7BFW2xaUsw7tZMr3QXG9dOzQ=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };

  # postInstall = ''
  #   mv $out/bin/bosh-cli $out/bin/bosh
  #   rm $out/bin/docs
  # '';
}
