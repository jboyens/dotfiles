{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  pkg = nixpkgs.qutebrowser;
  configDir = "/home/jboyens/.config/dotfiles/config";
  dicts = ["en-US"];
  extraConfig = "";
  userStyles = "";
in {
  home.packages = with nixpkgs; [
    pkg
    (makeDesktopItem {
      name = "qutebrowser-private";
      desktopName = "Qutebrowser (Private)";
      genericName = "Open a private Qutebrowser window";
      icon = "qutebrowser";
      exec = ''${pkg}/bin/qutebrowser -T -s content.private_browsing true'';
      categories = ["Network"];
    })
    # For Brave adblock in qutebrowser, which is significantly better than the
    # built-in host blocking. Works on youtube and crunchyroll ads!
    python39Packages.adblock
  ];

  home.file = {
    # ".config/qutebrowser" = {
    #   source = ../../../../config/qutebrowser;
    #   recursive = true;
    # };
    ".config/qutebrowser/extra/00-extraConfig.py".text = extraConfig;
    ".local/share/qutebrowser/userstyles.css".text = userStyles;
  };

  # Install language dictionaries for spellcheck backends
  home.activation.qutebrowserInstallDicts = lib.concatStringsSep "\\\n" (map (lang: ''
      if ! find "$XDG_DATA_HOME/qutebrowser/qtwebengine_dictionaries" -type d -maxdepth 1 -name "${lang}*" 2>/dev/null | grep -q .; then
        ${nixpkgs.python3}/bin/python ${pkg}/share/qutebrowser/scripts/dictcli.py install ${lang}
      fi
    '')
    dicts);
}
