{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  emacs,
  glib,
  gmime3,
  texinfo,
  xapian,
  coreutils,
  python3,
  gawk,
  gzip,
}:
stdenv.mkDerivation rec {
  pname = "mu";
  version = "1.11.28";

  outputs = ["out" "mu4e"];

  src = fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "309df647b8e2c7c6ad19ba7f01f0b6ccccc15c4e";
    hash = "sha256-Vb5AEgNin+DPqWF6QdeTlOVUkiX4jwwpTOv0gpJbAU4=";
  };

  postInstall = ''
    rm --verbose $mu4e/share/emacs/site-lisp/mu4e/*.elc
  '';

  postPatch = ''
    substituteInPlace build-aux/date.py \
      --replace-fail "/usr/bin/env python3" "${python3}/bin/python"
    substituteInPlace meson.build \
      --replace-fail "cp.full_path()" "'${coreutils}/bin/cp'" \
      --replace-fail "mv.full_path()" "'${coreutils}/bin/mv'" \
      --replace-fail "rm.full_path()" "'${coreutils}/bin/rm'" \
      --replace-fail "ln.full_path()" "'${coreutils}/bin/ln'" \
      --replace-fail "awk.full_path()" "'${gawk}/bin/awk'" \
      --replace-fail "gzip.full_path()" "'${gzip}/bin/gzip'"
    substituteInPlace lib/mu-maildir.cc \
      --replace-fail "/bin/mv" "${coreutils}/bin/mv"
  '';

  # move only the mu4e info manual
  # this has to be after preFixup otherwise the info manual may be moved back by _multioutDocs()
  # we manually move the mu4e info manual instead of setting
  # outputInfo to mu4e because we do not want to move the mu-guile
  # info manual (if it exists)
  postFixup = ''
    moveToOutput share/info/mu4e.info.gz $mu4e
    install-info $mu4e/share/info/mu4e.info.gz $mu4e/share/info/dir
    if [[ -a ''${!outputInfo}/share/info/mu-guile.info.gz ]]; then
      install-info --delete $mu4e/share/info/mu4e.info.gz ''${!outputInfo}/share/info/dir
    else
      rm --verbose --recursive ''${!outputInfo}/share/info
    fi
  '';

  buildInputs = [emacs glib gmime3 texinfo xapian];

  mesonFlags = [
    "-Dguile=disabled"
    "-Dreadline=disabled"
    "-Dlispdir=${placeholder "mu4e"}/share/emacs/site-lisp"
  ];

  mesonCheckFlags = [
    "--verbose"
  ];

  nativeBuildInputs = [pkg-config meson ninja python3];

  doCheck = true;

  meta = with lib; {
    description = "A collection of utilities for indexing and searching Maildirs";
    license = licenses.gpl3Plus;
    homepage = "https://www.djcbsoftware.nl/code/mu/";
    changelog = "https://github.com/djcb/mu/releases/tag/v${version}";
    maintainers = with maintainers; [antono chvp peterhoeg];
    mainProgram = "mu";
    platforms = platforms.unix;
  };
}
