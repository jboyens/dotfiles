{ stdenv, fetchFromGitHub, coreutils, gnugrep, gnused, makeWrapper, git
}:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "20201108";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "aa420e3f9681ce54cb3e2de10bd118f2664621ea";
    sha256 = "cb0IK5mGFUaLZoe24rkDYoad3q2ukKb/lV0oURCsPHM=";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-sync $out/bin/git-sync
  '';

  wrapperPath = with stdenv.lib; makeBinPath [
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
    maintainers = with stdenv.lib.maintainers; [ imalison ];
    license = stdenv.lib.licenses.cc0;
    platforms = with stdenv.lib.platforms; unix;
  };
}
