{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

let
  version = "0.17.0";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    sha256 = "sha256-lb+1E2X23PusY7mHQDCTjd6vlI9QX2ydLiPZqhpazpU=";
    stripRoot = false;
  };
in

buildGoModule rec {
  inherit version;

  pname = "fluxcd";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    sha256 = "sha256-Vpk+hfS1xAlivzDRgHxxhmIS10YPNmUttt4wYhoqhd8=";
  };

  vendorSha256 = "sha256-FUASe7EQ8YVv3R6fPPLtsvMibe00Ox596GoTyKt0S+E=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/flux" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests
  '';

  doCheck=false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${version} > /dev/null
  '';

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/flux completion $shell > flux.$shell
      installShellCompletion flux.$shell
    done
  '';

  meta = with lib; {
    description = "Open and extensible continuous delivery solution for Kubernetes";
    longDescription = ''
      Flux is a tool for keeping Kubernetes clusters in sync
      with sources of configuration (like Git repositories), and automating
      updates to configuration when there is new code to deploy.
    '';
    homepage = "https://fluxcd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jlesquembre superherointj ];
  };
}
