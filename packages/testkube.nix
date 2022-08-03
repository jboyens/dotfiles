{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.3.17";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-67hFQlWZfmfvHEU5CklgbJl3Pb9YnHhAfMCiY+qhWLo=";
  };

  vendorSha256 = "sha256-tekCASZ79vS1CHiNR2xH1iNpRFx98hcJi2PVMJnpwYw=";

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
