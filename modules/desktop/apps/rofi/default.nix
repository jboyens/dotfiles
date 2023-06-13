{ inputs, config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.rofi;
  hmcfg = config.home-manager.users.jboyens.config;

  template = builtins.readFile
    (inputs.stylix.sourceInfo.outPath + "/modules/rofi/template.mustache");
  templateExtra = builtins.readFile ./templateExtra.mustache;
  rofiOpacity =
    builtins.toString (builtins.ceil (config.stylix.opacity.popups * 100));
  finalString = ''
    * { background: rgba ( {{base00-rgb-r}}, {{base00-rgb-g}}, {{base00-rgb-b}}, ${rofiOpacity} % );
        lightbg: rgba ( {{base01-rgb-r}}, {{base01-rgb-g}}, {{base01-rgb-b}}, ${rofiOpacity} % );
        red: rgba ( {{base08-rgb-r}}, {{base08-rgb-g}}, {{base08-rgb-b}}, ${rofiOpacity} % );
        blue: rgba ( {{base0D-rgb-r}}, {{base0D-rgb-g}}, {{base0D-rgb-b}}, ${rofiOpacity} % );
        lightfg: rgba ( {{base06-rgb-r}}, {{base06-rgb-g}}, {{base06-rgb-b}}, ${rofiOpacity} % );
        foreground: rgba ( {{base05-rgb-r}}, {{base05-rgb-g}}, {{base05-rgb-b}}, ${rofiOpacity} % );
    }
  '' + builtins.toString template + templateExtra;
  finalFile = config.lib.stylix.colors {
    template = finalString;
    extension = ".rasi";
  };
in {
  options.modules.desktop.apps.rofi = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home.programs.rofi = {
      enable = true;
      cycle = true;
      package = pkgs.rofi-wayland.override {
        plugins = with pkgs; [
          pkgs.rofi-calc
          pkgs.rofi-emoji
          pkgs.rofi-file-browser
          pkgs.rofi-top
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
      theme = lib.mkForce finalFile;
      terminal = "${pkgs.foot}/bin/foot";
    };

    user.packages = with pkgs; [
      pkgs.rofi-bluetooth
      pkgs.rofi-power-menu
      pkgs.rofi-pulse-select
      pkgs.rofi-rbw
      pkgs.rofi-systemd

      # Fake rofi dmenu entries
      (makeDesktopItem {
        name = "rofi-browsermenu";
        desktopName = "Open Bookmark in Browser";
        icon = "bookmark-new-symbolic";
        exec = "${config.dotfiles.binDir}/rofi/browsermenu";
      })

      (makeDesktopItem {
        name = "rofi-browsermenu-history";
        desktopName = "Open Browser History";
        icon = "accessories-clock";
        exec = "${config.dotfiles.binDir}/rofi/browsermenu history";
      })

      (makeDesktopItem {
        name = "rofi-filemenu";
        desktopName = "Open Directory in Terminal";
        icon = "folder";
        exec = "${config.dotfiles.binDir}/rofi/filemenu";
      })

      (makeDesktopItem {
        name = "rofi-filemenu-scratch";
        desktopName = "Open Directory in Scratch Terminal";
        icon = "folder";
        exec = "${config.dotfiles.binDir}/rofi/filemenu -x";
      })

      (makeDesktopItem {
        name = "lock-display";
        desktopName = "Lock screen";
        icon = "system-lock-screen";
        exec = "${config.dotfiles.binDir}/zzz";
      })
    ];
  };
}
