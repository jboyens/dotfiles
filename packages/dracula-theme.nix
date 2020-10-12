{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "dracula-theme";
  version = "2020-08-31";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "bf8595d4b8d29e3a156f837f0afc20981f98672a";
    sha256 = "08cwgzm1bi3gsfjdpsdpj2060lm8g4a0s4a0i8m3l3gpy4xx39zf";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/Dracula
    cp -a * $out/share/themes/Dracula
    rm -r $out/share/themes/Dracula/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0kly7cbazzl4nkqddb7l9w07ll1plwjq0crjr6ip8rvj1vclccf7";

  meta = with stdenv.lib; {
    description = "A flat and light theme with a modern look";
    homepage = https://github.com/dracula/gtk;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [
      maintainers.pbogdan
    ];
  };
}
