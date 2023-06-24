{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.config-connector
      google-cloud-sdk.components.terraform-tools
    ])
    cloud-sql-proxy
  ];

  home.sessionVariables.USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
}
