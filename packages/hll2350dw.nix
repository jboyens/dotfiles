{ stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, file, a2ps
, coreutils, gawk, perl, gnugrep, which }:

let
  version = "4.0.0-1";
  lprdeb = fetchurl {
    url =
      "https://download.brother.com/welcome/dlf103566/hll2350dwpdrv-${version}.i386.deb";
    sha256 = "863c6a40b3b6883376834acf98a6178d385b3a95ecc4cbf3604f15102c85f02c";
  };
in stdenv.mkDerivation {
  name = "cups-brother-hll2350dw";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/HLL2350DW/lpd/lpdfilter \
      --replace /opt "$out/opt" \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/HLL2350DW/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HLL2350DW\"; #"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2350DW/lpd/x86_64/brprintconflsr3
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/brother/Printers/HLL2350DW/lpd/x86_64/rawtobr3

    for f in \
      $out/opt/brother/Printers/HLL2350DW/cupswrapper/lpdwrapper \
      $out/opt/brother/Printers/HLL2350DW/cupswrapper/paperconfigml2 \
    ; do
      wrapProgram $f \
        --prefix PATH : ${
          stdenv.lib.makeBinPath [ coreutils ghostscript gnugrep gnused ]
        }
    done

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/HLL2350DW/lpd/lpdfilter $out/lib/cups/filter/brother_lpdwrapper_HLL2350DW

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HLL2350DW/cupswrapper/brother-HLL2350DW-cups-en.ppd $out/share/cups/model/

    wrapProgram $out/opt/brother/Printers/HLL2350DW/lpd/lpdfilter \
      --prefix PATH ":" ${
        stdenv.lib.makeBinPath [
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]
      }
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.brother.com/";
    description = "Brother hl-l2350dw printer driver";
    license = licenses.unfree;
    platforms = platforms.linux;
    downloadPage =
      "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=es&prod=hll2350dw_us_eu_as&os=128&flang=English";
    maintainers = [ maintainers.jboyens ];
  };
}
