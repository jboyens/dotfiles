{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-CSIzja0ou4JPASIpIFW0Pbw/J+aD8TJ5LFzJQFXTRa8=";
  };

  vendorSha256 = "sha256-ttrkV6WtDbhxmx94usHF5ffDC5uZ/uf1vmS2XWdAmog=";

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
