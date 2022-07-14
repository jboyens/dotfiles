{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bosh-cli-${version}";
  version = "7.0.1";

  goPackagePath = "github.com/cloudfoundry/bosh-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${version}";
    sha256 = "sha256-CNicDFmWq2tgw3LEw8nOlwewY3cpzwS9ea4fxbwVJc0=";
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
