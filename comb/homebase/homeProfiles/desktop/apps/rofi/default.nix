{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  inherit (inputs.cells.homebase) nixosProfiles;
  styles = nixosProfiles.styles.config;

  inherit (styles.styling) colors;
in {
  home.file = {
    ".config/rofi/themes/base16.rasi" = {
      text = ''
        @import "themes/base16-base.rasi"

        ${builtins.readFile ./overrides.rasi}
      '';
    };
    ".config/rofi/themes/base16-base.rasi" = {
      text = builtins.readFile (colors inputs.base16-rofi);
    };
    ".config/rofi/theme" = {
      source = ./_theme;
      recursive = true;
    };
  };

  programs.rofi = {
    enable = true;
    cycle = true;
    package = nixpkgs.rofi-wayland.override {
      plugins = with nixpkgs; [
        rofi-calc
        rofi-emoji
        rofi-file-browser
        rofi-top
      ];
    };
    extraConfig = {
      icon-theme = "Paper";
      disable-history = false;

      kb-accept-entry = "Return,Control+m,KP_Enter";
      kb-row-down = "Down,Control+n,Control+j";
      kb-row-up = "Up,Control+p,Control+k";
      kb-remove-to-eol = "";
    };
    theme = "base16";
    terminal = "foot";
  };

  home.packages = with nixpkgs; [
    rofi-bluetooth
    rofi-power-menu
    rofi-pulse-select
    rofi-rbw
    rofi-systemd

    # Fake rofi dmenu entries
    (makeDesktopItem {
      name = "rofi-browsermenu";
      desktopName = "Open Bookmark in Browser";
      icon = "bookmark-new-symbolic";
      exec = "\\$DOTFILES_BIN/rofi/browsermenu";
    })

    (makeDesktopItem {
      name = "rofi-browsermenu-history";
      desktopName = "Open Browser History";
      icon = "accessories-clock";
      exec = "\\$DOTFILES_BIN/rofi/browsermenu history";
    })

    (makeDesktopItem {
      name = "rofi-filemenu";
      desktopName = "Open Directory in Terminal";
      icon = "folder";
      exec = "\\$DOTFILES_BIN/rofi/filemenu";
    })

    (makeDesktopItem {
      name = "rofi-filemenu-scratch";
      desktopName = "Open Directory in Scratch Terminal";
      icon = "folder";
      exec = "\\$DOTFILES_BIN/rofi/filemenu -x";
    })

    (makeDesktopItem {
      name = "lock-display";
      desktopName = "Lock screen";
      icon = "system-lock-screen";
      exec = "\\$DOTFILES_BIN/zzz";
    })
  ];
}
