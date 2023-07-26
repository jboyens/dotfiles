{
  lib,
  slack,
  sources,
  stdenv,
  ...
}:
(slack.override {inherit stdenv;}).overrideAttrs (oa: {
  inherit (sources.slack) version src;
})
