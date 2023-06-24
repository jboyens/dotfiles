{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home = {
    packages = with nixpkgs; [
      go-jsonnet
      hadolint
      istioctl
      kind
      krew
      kube3d
      kubectl
      kubernetes-helm
      kustomize
      minikube
      open-policy-agent
      stern
      terraform
      tilt
      # sloth
      # my.google-cloud-sdk-gke-gcloud-auth-plugin
    ];

    shellAliases.k = "kubectl";

    sessionPath = ["$HOME/.krew/bin"];
  };

  programs.k9s.enable = true;
}
