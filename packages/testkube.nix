{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.10.38";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-c3LUzLrx0VbFEzqMDNSbNs7Uymcsa8c85MXR3vNN7Jw=";
  };

  vendorSha256 = "sha256-DLh4uKT4/YbA0ZjEZXmryyB5BnlL2XD+8JvHy+Su6pM=";

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
