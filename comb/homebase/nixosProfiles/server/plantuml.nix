{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  services.plantuml-server = {
    enable = true;
    listenPort = 7865;
    allowPlantumlInclude = true;
  };
}
