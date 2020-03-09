{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "credhub-cli";
  version = "2.7.0";

  goPackagePath = "code.cloudfoundry.org/credhub-cli";

  src = fetchFromGitHub {
    owner = "cloudfoundry-incubator";
    repo = pname;
    rev = version;
    sha256 = "1dgzq74vr1zf1hqwzfsadmmbdcc15yyn2k2n1a1szzjvybw5cqf5";
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
