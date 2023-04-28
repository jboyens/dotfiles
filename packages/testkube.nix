{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "testkube";
  version = "1.11.9";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    sha256 = "sha256-wZnI2nQFtFzKGuP9gdh97uSlGERa8SuLd5R7Z2QnZmY=";
  };

  vendorSha256 = "sha256-iyR9H5T1eRjEx3vUgxUkXK6fgvJfLb7ux7MdIM3vPOY=";

  doCheck = false;
  subPackages = [ "cmd/kubectl-testkube" ];

  meta = with lib; {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = https://github.com/kubeshop/testkube/;
    license = licenses.mit;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
