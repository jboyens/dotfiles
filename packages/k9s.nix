{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    sha256 = "sha256-6A6RxvobT0T/Pbd7Zcn8++I/7OVAhXSZI1NhYeDB3iY=";
  };

  vendorSha256 = "sha256-1FmhoLfTQSygAScbvABHZJO3611T7cfuCboyu2ShbNo=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";

    homepage = https://github.com/derailed/k9s;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
