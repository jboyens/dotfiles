{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    go
    gopls
    gocode
    gore
    gotools
    gotests
    gomodifytags
    golangci-lint
    delve
  ];
}
