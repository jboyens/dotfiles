{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bosh-cli-${version}";
  version = "6.3.1";

  goPackagePath = "github.com/cloudfoundry/bosh-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${version}";
    sha256 = "1rbb9cqzxnvp6vnd6pjhk1im09lngjy2h586j3mfwrfrpv17c7xb";
  };

  meta = with stdenv.lib; {
    description = "The command-line interface to the BOSH cloud orchestration system";
    homepage = https://github.com/cloudfoundry/bosh-cli;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };

  postInstall = ''
    mv $bin/bin/bosh-cli $bin/bin/bosh
    rm $bin/bin/docs
  '';
}
