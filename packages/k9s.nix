{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.25.21";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    sha256 = "sha256-ziIMTMK6G8vXje6GWPvcIWmlubq75XVrJUzZlA+R0Rc=";
  };

  vendorSha256 = "sha256-wL8Unht/ZRAGDuC/U4SFV5PdExy78F4DMyM8+7CMtOY=";

  doCheck = false;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";

    homepage = https://github.com/derailed/k9s;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
