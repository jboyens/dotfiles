{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) writeScriptBin;
in {
  virtualisation.lxd.enable = true;

  environment.systemPackages = [
    (writeScriptBin "lxc-build-nixos-image" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nixos-generators
      set -xe
      config=$1
      metaimg=`nixos-generate -f lxc-metadata \
        | xargs -r cat \
        | awk '{print $3}'`
      img=`nixos-generate -c $config -f lxc \
        | xargs -r cat \
        | awk '{print $3}'`
      lxc image import --alias nixos $metaimg $img
    '')
  ];
}
