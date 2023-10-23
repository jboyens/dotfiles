args_ @ {
  lib,
  fetchFromGitea,
  stdenv,
  fuzzel,
  sources,
  ...
}: let
  ignore = ["fuzzel" "sources"];
  args = lib.filterAttrs (n: v: (!builtins.elem n ignore)) args_;
in
  (fuzzel.override args).overrideAttrs (old: {
    inherit (sources.fuzzel) src;
    version = "${sources.fuzzel.version}";
  })
