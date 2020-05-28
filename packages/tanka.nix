{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "tanka";
  pname = "${name}-${version}";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = name;
    rev = "v${version}";
    sha256 = "18psf1mxxki68n3crdh0ys5cgy7i9n0klqxw674fbqkzah6xcw46";
  };

  modSha256 = "0pv3lhzl96ygzh9y01hi9klrrk403ii92imr9yrbimaf7rsvyvjp";

  subPackages = ["cmd/tk"];

  meta = with stdenv.lib; {
   description = "Tanka is a composable configuration utility for Kubernetes. It leverages the Jsonnet language to realize flexible, reusable and concise configuration";
    homepage = https://github.com/grafana/tanka;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
