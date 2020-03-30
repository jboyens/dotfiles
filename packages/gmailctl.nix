{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gmailctl-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g581gdkib7bj86blpm8skjvbnivmzh9ddikxai9hr5qq231j1pb";
  };

  modSha256 = "1c4mz6yxwiv9185algqhd7fxr3d7048y1qiqzjnv54bppcpvsq4l";

  subPackages = ["cmd/gmailctl"];

  meta = with stdenv.lib; {
   description = "Helps you generate and maintain Gmail filters in a declarative way.";
    homepage = https://github.com/mbrt/gmailctl;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
