{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bosh-bootloader-${version}";
  version = "8.4.0";

  goPackagePath = "github.com/cloudfoundry/bosh-bootloader";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-bootloader";
    rev = "v${version}";
    sha256 = "1nchnkn4ks8ca4nbd19xwxivn6jldl1w6wzfflrn4qq1z409yncg";
  };

  meta = with stdenv.lib; {
    description = "bosh-bootloader or (bbl - pronounced: bubble) is a command line utility for standing up BOSH on an IaaS";
    homepage = https://github.com/cloudfoundry/bosh-bootloader;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
  };

  # postInstall = ''
  #   mv $bin/bin/bosh-cli $bin/bin/bosh
  #   rm $bin/bin/docs
  # '';
}
