{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "macbook12-spi-driver-${version}-${kernel.version}";
  version = "20200331";

  src = fetchFromGitHub {
    owner = "roadrunner2";
    repo = "macbook12-spi-driver";
    rev = "ddfbc7733542b8474a0e8f593aba91e06542be4f";
    sha256 = "0d1a9kvvs09l9g562ghaq9vha3gpf6mifban2j40nixbrzcpz70b";
  };

  preBuild = ''
    sed -e "s@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@" -i Makefile
  '';

  installPhase = ''
    install -v -D -m 644 applespi.ko "$out/lib/modules/${kernel.modDirVersion}/updates/applespi.ko"
    install -v -D -m 644 apple-ibridge.ko "$out/lib/modules/${kernel.modDirVersion}/updates/apple_ibridge.ko"
    install -v -D -m 644 apple-ib-tb.ko "$out/lib/modules/${kernel.modDirVersion}/updates/apple_ib_tb.ko"
    install -v -D -m 644 apple-ib-als.ko "$out/lib/modules/${kernel.modDirVersion}/updates/apple_ib_als.ko"
  '';

  dontStrip = true;
  dontPatchElf = true;

  enableParallelBuilding = true;

  meta = {
    description = "Linux kernel drivers for Apple SPI devices";
    homepage = http://github.com/roadrunner2/macbook12-spi-driver;
    license = stdenv.lib.licenses.gpl2;
  };
}
