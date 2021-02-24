{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bosh-cli-${version}";
  version = "6.4.0";

  goPackagePath = "github.com/cloudfoundry/bosh-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${version}";
    sha256 = "10wbnmm2i2rr6n29l0xskzfcfr6ipkkvc8qz7savlg0mxya5fgs5";
  };

  meta = with stdenv.lib; {
    description = "The command-line interface to the BOSH cloud orchestration system";
    homepage = https://github.com/cloudfoundry/bosh-cli;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };

  postInstall = ''
    mv $out/bin/bosh-cli $out/bin/bosh
    rm $out/bin/docs
  '';
}
