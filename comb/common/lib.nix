{
  inputs,
  cell,
}: let lib = cell.pkgs.lib // builtins; in lib
