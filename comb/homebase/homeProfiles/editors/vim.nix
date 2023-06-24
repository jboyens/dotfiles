{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = with nixpkgs; [
    editorconfig-core-c
    neovim-unwrapped
  ];

  home.shellAliases = {
    vim = "nvim";
    v = "nvim";
  };
}
