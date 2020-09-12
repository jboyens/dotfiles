{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.10.0";

  goPackagePath = "github.com/profclems/glab";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "13j0hvnn7hns2azznn7b4069mmk6xisyygmf7lqw152rariccl5d";
  };

  vendorSha256 = "1f3fkshfsw7aqnhjfbsjs43zl905r747fdi3i2fpfv1h7rfp4ib6";

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
