{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  cyrus_sasl,
  sources,
}:
stdenv.mkDerivation rec {
  inherit (sources.cyrus-sasl-xoauth2) src pname;

  version = lib.removePrefix "v" sources.cyrus-sasl-xoauth2.version;

  nativeBuildInputs = [autoconf automake libtool cyrus_sasl];
  buildInputs = [];

  preConfigure = "./autogen.sh";
  makeFlags = ["CYRUS_SASL_PREFIX=${placeholder "out"}"];

  meta = with lib; {
    homepage = "https://github.com/moriyoshi/cyrus-sasl-xoauth2";
    description = "This is a plugin implementation of XOAUTH2.";
    maintainers = with maintainers; [];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
