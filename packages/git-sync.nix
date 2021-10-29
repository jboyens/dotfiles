{ stdenv, lib, fetchFromGitHub, coreutils, gnugrep, gnused, makeWrapper, git }:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "20211029";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "12e0b753055f5d7ccb904b556db982ccf7e8aa84";
    sha256 = "sha256-DtHHW73milkYO+9fHnEf3RZvGpmNJnWOgiE5NAORzY8=";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-sync $out/bin/git-sync
  '';

  wrapperPath = with lib; makeBinPath [
    coreutils
    git
    gnugrep
    gnused
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "A script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}
