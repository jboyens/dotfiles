{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  my = cell.packages;
in {
  packages = with nixpkgs; [
    # for calculations
    bc

    # for watching networks
    bwm_ng

    # for guessing mime-types
    file

    # for checking out block devices
    hdparm

    # for checking in on block devices
    iotop

    # for understanding who has what open
    lsof

    # for running commands repeatedly
    entr

    # for downloading things rapidly
    axel

    # for monitoring
    bottom
    btop

    # for json parsing
    jq

    # for yaml parsing
    yq-go

    # for pretty du
    du-dust

    # dig
    bind

    # sound
    pavucontrol
    pamixer

    # network
    mtr

    # zips
    unzip

    # certs/keys
    openssl

    # wireless
    iw

    # notify-send
    libnotify

    wl-clipboard-x11

    envsubst

    age

    glab

    jira-cli-go

    my.testkube

    nvd

    # markdown-to-confluence
  ];
}
