{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    (lib.hiPrio ruby_3_2)
    solargraph
  ];
}
