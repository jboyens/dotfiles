{
  inputs,
  cell,
}: let
  common = {
    bee.system = "x86_64-linux";
    bee.pkgs = inputs.cells.common.pkgs;
    deployment = {
      allowLocalDeployment = true;
      tags = ["all"];
    };
  };
in
  inputs.hive.findLoad {
    inherit cell;
    inputs = inputs // {inherit common;};
    block = ./.;
  }
