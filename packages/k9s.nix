{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    sha256 = "sha256-Czjx6YTyFKAP8ZuwBpTpRfjDdRdd8GQ0ggbe5LMb8uA=";
  };

  vendorSha256 = "sha256-rnROcJA4f0YjDGKEncrMmf/43VKrbgpmM3TvV1MMiWU=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";

    homepage = https://github.com/derailed/k9s;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
