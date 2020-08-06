{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "gmailctl-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "08q4yjfbwlldirf3j5db18l8kn6sf288wd364s50jlcx2ka8w50j";
  };

  modSha256 = "1c7dk6l8lkq2j04cp5g97hwkwfmmyn5r0vpr5zpavvalxgjidsf4";

  subPackages = ["cmd/gmailctl"];

  meta = with stdenv.lib; {
   description = "Helps you generate and maintain Gmail filters in a declarative way.";
    homepage = https://github.com/mbrt/gmailctl;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
