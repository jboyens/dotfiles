{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "tanka-${version}";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tanka";
    rev = "v${version}";
    sha256 = "0hp10qgalglsdhh6z6v4azh2hsr89mdrv1g5lssfl5jyink409yd";
  };

  modSha256 = "0hgyibmxv4pkgwnw2ijnlga9mx2qj9liq529nvqm4j4hmj1xg4l5";

  subPackages = ["cmd/tk"];

  meta = with stdenv.lib; {
   description = "Tanka is a composable configuration utility for Kubernetes. It leverages the Jsonnet language to realize flexible, reusable and concise configuration";
    homepage = https://github.com/grafana/tanka;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = platforms.unix;
  };
}
