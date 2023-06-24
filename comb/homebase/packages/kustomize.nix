{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  sources,
}:
buildGoModule rec {
  inherit (sources.kustomize) pname src;

  version = lib.removePrefix "kustomize/v" sources.kustomize.version;

  ldflags = let
    t = "sigs.k8s.io/kustomize/api/provenance";
  in [
    "-s"
    "-X ${t}.version=${version}"
    "-X ${t}.gitCommit=kustomize/v${version}"
  ];

  GOWORK = "off";

  # avoid finding test and development commands
  modRoot = "kustomize";

  vendorSha256 = "sha256-E9ICcp8MgHEtChCwxICwo2Ghz4dh3uw4blD1KGJEbCI=";

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
