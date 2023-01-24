{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.8.30";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-YYBUzxHG9gmonM9KtBDqLQlFFrUVdkPGb8MJMjhdOAI=";
  };

  vendorSha256 = "sha256-PU5FdqHprbIzwBD3/96thVUe9DvOrhgeDm4yUV/IUrg=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
