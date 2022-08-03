{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pack";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    rev = "v${version}";
    sha256 = "sha256-b1lqgY6pu4yt3yY2UupG7PQUkgotK0VDffCW/0thxoo=";
  };

  vendorSha256 = "sha256-JqSk4w0chtWNYDQXo8oh5spAxor2kixo3fZcpV4LJ+8=";

  ldflags = [
    "-s -w -X 'github.com/buildpacks/pack.Version=${version}'"
  ];
  subPackages = [ "cmd/pack" ];

  meta = with lib; {
    description = "CLI for building apps using Cloud Native Buildpacks";
    homepage = https://github.com/buildpacks/pack;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
