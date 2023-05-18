{
  lib,
  buildGo119Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo119Module rec {
  pname = "kustomize";
  version = "5.0.3";

  ldflags = let
    t = "sigs.k8s.io/kustomize/api/provenance";
  in [
    "-s"
    "-X ${t}.version=${version}"
    "-X ${t}.gitCommit=${src.rev}"
  ];

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "kustomize/v${version}";
    sha256 = "sha256-VKDLutzt5mFY7M9zmtEKvBjRD8+ea1Yil/NupvWBoVU=";
  };

  GOWORK = "off";

  # avoid finding test and development commands
  modRoot = "kustomize";

  vendorSha256 = "sha256-A0SYKXiWGFXj0csTXBSrlf8u0aTzng7cdZwnzFRA7dk=";

  nativeBuildInputs = [installShellFiles];

  postInstall = ''
    installShellCompletion --cmd kustomize \
      --bash <($out/bin/kustomize completion bash) \
      --fish <($out/bin/kustomize completion fish) \
      --zsh <($out/bin/kustomize completion zsh)
  '';

  meta = with lib; {
    description = "Customization of kubernetes YAML configurations";
    longDescription = ''
      kustomize lets you customize raw, template-free YAML files for
      multiple purposes, leaving the original YAML untouched and usable
      as is.
    '';
    homepage = "https://github.com/kubernetes-sigs/kustomize";
    license = licenses.asl20;
    maintainers = with maintainers; [carlosdagos vdemeester periklis zaninime Chili-Man saschagrunert];
  };
}
