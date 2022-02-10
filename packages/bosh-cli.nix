{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bosh-cli-${version}";
  version = "6.4.12";

  goPackagePath = "github.com/cloudfoundry/bosh-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${version}";
    sha256 = "sha256-X4bUF49jkO0cEP17XlZrfkl+saRYCDQIo6sfsaB3uVQ=";
  };

  meta = with lib; {
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
