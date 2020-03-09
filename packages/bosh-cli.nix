{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "bosh-cli";
  version = "v6.2.1";

  goPackagePath = "github.com/cloudfoundry/bosh-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = pname;
    rev = version;
    sha256 = "12isqj3m05xkm9vjgcigkpa663z858yc2l4hi1nfldw6cca90kc6";
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
