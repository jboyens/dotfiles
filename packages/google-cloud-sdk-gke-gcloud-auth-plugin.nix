{ lib, stdenv, fetchurl, dpkg, google-cloud-sdk }:

let
in stdenv.mkDerivation rec {
  pname = "google-cloud-sdk-gke-gcloud-auth-plugin";
  inherit (google-cloud-sdk) version;
  src = fetchurl {
    url = "https://packages.cloud.google.com/apt/pool/google-cloud-sdk-gke-gcloud-auth-plugin_${version}-0_amd64_b1a5d390bd2242acdb8644cc2e8b93d981b4382169c26bed2fb9c2f2fd44fdf9.deb";
    sha256 = "sha256-saXTkL0iQqzbhkTMLouT2YG0OCFpwmvtL7nC8v1E/fk=";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ dpkg ];
  buildInputs = [ ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/lib/google-cloud-sdk/bin/gke-gcloud-auth-plugin $out/bin
  '';

  meta = with lib; {
    description = "GKE Cloud Authentication Plugin for kubectl";
    homepage = https://cloud.google.com;
    license = licenses.asl20;
    maintainers = [ maintainers.jboyens ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
