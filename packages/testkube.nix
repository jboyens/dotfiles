{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-JyjBOocS3N9xtLpE9Yv+nhR25mjDbLG0P8Hf302xpAw=";
  };

  vendorSha256 = "sha256-hibzJVxq3YlJeGt0G8WMovUsrp2vYn8DVSziR6QQ0Po=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };

  # postInstall = ''
  #   mv $out/bin/bosh-cli $out/bin/bosh
  #   rm $out/bin/docs
  # '';
}
