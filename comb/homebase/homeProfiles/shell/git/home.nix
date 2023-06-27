{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  packages = with nixpkgs;
  with gitAndTools; [
    gitAndTools.git-annex
    gitAndTools.gh
    gitAndTools.git-open
    gitAndTools.diff-so-fancy
    gitAndTools.git-crypt
    gitAndTools.git-sync
    gitAndTools.git-delete-merged-branches
  ];
}
