{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "credhub-cli-${version}";
  version = "2.8.0";

  goPackagePath = "code.cloudfoundry.org/credhub-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry-incubator";
    repo = "credhub-cli";
    rev = version;
    sha256 = "0fm9izb45q19lgxqnvkqh55s8yg1vgjg6m9fnas2c10m4w0p9in8";
  };

  meta = with stdenv.lib; {
    description = "The command-line interface to the Credhub credential storage system";
    homepage = https://github.com/cloudfoundry-incubator/credhub-cli;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };

  postInstall = ''
    mv $bin/bin/credhub-cli $bin/bin/credhub
  '';
}
