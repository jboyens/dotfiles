{
  inputs,
  cell,
  config,
  ...
}: let
  inherit (inputs) nixpkgs;

  lib = builtins // nixpkgs.lib // cell.lib;

  inherit (config.styling) colors fonts fontSizes;
in {
  wayland.windowManager.sway = {
    enable = true;
    package = null; # must be managed at the NixOS level
    systemd.enable = true;
    swaynag.enable = true;

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_WEBRENDER=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
      export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
      export NIXOS_OZONE_WL=1
      export XCURSOR_PATH=${nixpkgs.dracula-icon-theme}/share/icons
      export XCURSOR_THEME=Dracula
      export WLR_DRM_NO_MODIFIERS=1
    '';

    config = {
      terminal = "foot";

      window.titlebar = false;
      floating.titlebar = false;

      focus = {
        followMouse = true;
        mouseWarping = "container";
        newWindow = "smart";
      };

      gaps = {
        inner = 8;
        smartGaps = true;
      };

      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_model = "dell";
          xkb_layout = "us";
          xkb_variant = "dvorak";
          xkb_options = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
        };

        "1739:31251:SYNA2393:00_06CB:7A13_Touchpad" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        "1739:31251:SYNA2393:00_06CB:7A13_Mouse" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };
      };

      workspaceOutputAssign = [];

      startup = [
        {
          command = "$DOTFILES/bin/laptop.sh";
          always = true;
        }
        {
          command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${nixpkgs.wob}/bin/wob";
          always = false;
        }
        {
          command = "persway daemon -w -d stack_main";
          always = false;
        }
        {
          command = "${nixpkgs.swayr}/bin/swayrd";
          always = false;
        }
        {
          command = "${nixpkgs.ydotool}/bin/ydotoold --socket-path=/run/user/%U/.ydotool_socket --socket-perm=0600 --socket-own %U:%G";
          always = false;
        }
      ];
    };
  };

  services.wlsunset = {
    enable = true;
    latitude = "47.6062";
    longitude = "-122.3321";
  };

  gtk = {
    enable = true;

    theme = {
      # package = nixpkgs.adw-gtk3;
      # name = "adw-gtk3";
      package = nixpkgs.dracula-theme;
      name = "Dracula";
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "10x10";
        dpi-aware = lib.mkForce "yes";
        font = "${fonts.monospace.name}:size=${toString fontSizes.terminal}";
      };

      colors = {
        foreground = colors.base05-hex;
        background = colors.base00-hex;
        regular0 = colors.base00-hex;
        regular1 = colors.base08-hex;
        regular2 = colors.base0B-hex;
        regular3 = colors.base0A-hex;
        regular4 = colors.base0D-hex;
        regular5 = colors.base0E-hex;
        regular6 = colors.base0C-hex;
        regular7 = colors.base05-hex;
        bright0 = colors.base03-hex;
        bright1 = colors.base08-hex;
        bright2 = colors.base0B-hex;
        bright3 = colors.base0A-hex;
        bright4 = colors.base0D-hex;
        bright5 = colors.base0E-hex;
        bright6 = colors.base0C-hex;
        bright7 = colors.base07-hex;
      };
      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
      };
    };
  };
}
