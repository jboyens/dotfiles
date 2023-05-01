{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "markdown-to-confluence";
  version = "20230118";

  src = fetchFromGitHub {
    owner = "vmware-tanzu-labs";
    repo = "markdown-to-confluence";
    rev = "ffb39741916e8428fa606c95d84a4c09b1ed64e1";
    sha256 = "sha256-ekWGDi68anVg75GNjDAheKYk2YXZEbFPVoMFwcGr5ng=";
  };

  format = "other";

  checkPhase = ''
    $out/bin/markdown-to-confluence --help >/dev/null
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/${python3.sitePackages}
    cp markdown-to-confluence.py $out/bin/markdown-to-confluence
    chmod +x $out/bin/markdown-to-confluence
    cp -r $src/markdown_to_confluence $out/${python3.sitePackages}

    runHook postInstall
    '';

  propagatedBuildInputs = with python3.pkgs; [ GitPython mistune pyyaml requests ];

  meta = with lib; {
    description = "markdown-to-confluence";
    homepage = "https://github.com/vmware-tanzu-labs/markdown-to-confluence";
    license = licenses.asl20;
    maintainers = with maintainers; [ jboyens ];
  };
}
