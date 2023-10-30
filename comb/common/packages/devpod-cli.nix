{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  name = "devpod";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "devpod";
    rev = "v${version}";
    hash = "sha256-s5O7pcrynfwgye6NdcF6XOCRDf1VS9i8Z3ghOQnjiKg=";
  };

  vendorHash = null;

  doCheck = false;

  meta = with lib; {
    description = "Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker";
    homepage = "https://github.com/loft-sh/devpod";
    license = licenses.mpl20;
    maintainers = [];
    mainProgram = "devpod";
    platforms = platforms.all;
  };
}
