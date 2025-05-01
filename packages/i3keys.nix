{
  lib,
  buildGoModule,
  fetchFromGitHub,
  xorg,
}:
buildGoModule rec {
  pname = "i3keys";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = "i3keys";
    rev = "99e368e4cbb4f82f4e9461c3fd43054add0c3c37";
    hash = "sha256-YBHItVj6+pXfkI/zlH0Ivg4zThebec17m5OAzwTC9Fs=";
  };

  vendorHash = "sha256-E9695Y+/fUUTYAay6TxGtX01btnnY6e+2WVQjGMd2f0=";

  CGO_ENABLED = true;

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ];

  meta = with lib; {
    description = "Lists available bindings for i3 or Sway with a graphical or text keyboard";
    homepage = "https://github.com/RasmusLindroth/i3keys";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
