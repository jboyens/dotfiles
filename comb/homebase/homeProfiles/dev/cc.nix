{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    clang
    (lib.hiPrio gcc)
    bear
    gdb
    cmake
    llvmPackages.libcxx
  ];
}
