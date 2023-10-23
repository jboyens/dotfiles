{
  inputs,
  cell,
}: let
  inherit (inputs) common;
in {
  imports = [cell.nixosConfigurations.chappie];
  inherit (common) bee;

  deployment = common.deployment // {tags = ["laptops"];};
}
