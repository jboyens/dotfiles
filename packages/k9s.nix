{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "b24759e6fecb14ecdba10a0288115c3a60e9c9ad";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = version;
    sha256 = "sha256-0/QWNoBUFLUL6elNs9/foUh51+hhB/sIHQ1ztBIfa9c=";
  };

  vendorSha256 = "sha256-mMob7M9RQlqaVK0DgHpaAK9d1btzfQetnliUqFTvjJQ=";

  doCheck = false;

  meta = with lib; {
    description = "Krew is the package manager for kubectl plugins";

    homepage = https://github.com/kubernetes-sigs/krew;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
