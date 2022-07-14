{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-VZKk8ed3042HkJxYPw10t5LEPoU1g8+YEet6pf1+qF0=";
  };

  vendorSha256 = "sha256-HB7DSJYjQo7uOW6zd/WKulPb1VX0dj+3/peMKAnzkRU=";

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
