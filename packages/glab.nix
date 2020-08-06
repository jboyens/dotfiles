{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "v1.7.0";

  goPackagePath = "github.com/profclems/glab";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = version;
    sha256 = "078rcrvnnhqblpzynwzsb3rkpls5mb4fpyc1l1dp5aqh8m87p7f7";
  };

  modSha256 = "0gbs5y4i82s0f0g9gkwrb0ldcd8mibmhx38xgap2fgpsj1d9m4yn";

  subPackages = [ "cmd/glab" ];

  meta = with stdenv.lib; {
    description = "GLab is an open source Gitlab Cli tool written in Go (golang) to help work seamlessly with Gitlab from the command line.";
    homepage = https://github.com/profclems/glab;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };

  # postInstall = ''
  #   mv $bin/bin/bosh-cli $bin/bin/bosh
  #   rm $bin/bin/docs
  # '';
}
