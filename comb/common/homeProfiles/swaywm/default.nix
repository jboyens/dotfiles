{inputs, ...}: let
  inherit (inputs) nixpkgs;
in {
  home.packages = [
    nixpkgs.dotool
  ];

  systemd.user.services.dotoold = {
    Install = {
      WantedBy = ["sway-session.target"];
    };

    Service = {
      Environment = "PATH=${nixpkgs.coreutils}/bin:$PATH";
      ExecStart = "${nixpkgs.dotool}/bin/dotoold";
      Restart = "on-failure";
    };

    Unit = {
      After = "graphical-session.target";
      Description = "dotool reads commands from stdin and simulates keyboard and pointer events";
      Documentation = "https://git.sr.ht/~geb/dotool";
      PartOf = "graphical-session.target";
    };
  };

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

    extraConfig = ''
      bindswitch --locked lid:toggle exec $DOTFILES/bin/laptop.sh
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

        "10182:3936:VEN_27C6:00_27C6:0F60_Touchpad" = {
          click_method = "clickfinger";
          drag = "enabled";
          dwt = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        "10182:3936:VEN_27C6:00_27C6:0F60_Mouse" = {
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
        {
          command = "${nixpkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          always = false;
        }
      ];
    };
  };
}
