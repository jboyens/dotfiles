{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "checkexec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kurtbuilds";
    repo = "checkexec";
    rev = "v${version}";
    hash = "sha256-osLtyVXR4rASwRJmbu6jD8o3h12l/Ty4O8/XTl5UzB4=";
  };

  cargoHash = "sha256-ivNhvd+Diq54tmJfveJoW8F/YN294/zRCbsQPwpufak=";

  meta = with lib; {
    description = "A CLI tool to conditionally execute commands only when files in a dependency list have been updated. Like `make`, but standalone";
    homepage = "https://github.com/kurtbuilds/checkexec";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
