{
  inputs,
  cell,
  config,
  ...
} @ args: let
  inherit (inputs) nixpkgs;

  lib = builtins // nixpkgs.lib // cell.lib;

  inherit (config.styling) colors fonts fontSizes;
in {
  imports = [
    (import ./_swaylock.nix args)
    (import ./_bars.nix args)
    (import ./_keybindings.nix args)
    (import ./_colors.nix args)
    (import ./_window-commands.nix args)
  ];

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

      output = {
        "*" = {
          bg = "/home/jboyens/wallpaper/second-collection/illustrations/galaxy/dracula-galaxy-282a36.png fill";
        };

        eDP-1 = {
          mode = "1920x1080@60Hz";
          position = "6940,2160";
        };

        "LG Electronics LG Ultra HD 0x00011A21" = {
          mode = "3840x2160@60Hz";
          position = "0,0";
          scale = "1.0";
        };

        "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E" = {
          mode = "3840x2160@60Hz";
          position = "3840,0";
          scale = "1.0";
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

  services.mako = let
    iconPath = let
      basePaths = [
        "/run/current-system/sw"
        # inputs.home-manager.config.home.profileDirectory
        "/home/jboyens/.nix-profile"
        "/etc/profiles/per-user/jboyens"
      ];
      themes = ["Dracula" "Adwaita" "hicolor"];
      mkPath = {
        basePath,
        theme,
      }: "${basePath}/share/icons/${theme}";
    in
      lib.concatMapStringsSep ":" mkPath (lib.cartesianProductOfSets {
        basePath = basePaths;
        theme = themes;
      });
  in {
    inherit iconPath;

    enable = true;
    actions = true;
    anchor = "top-right";
    borderRadius = 2;
    borderSize = 1;
    defaultTimeout = 0;
    height = 1000;
    icons = true;
    ignoreTimeout = false;
    margin = "4,26";
    markup = true;
    maxVisible = -1;
    padding = "20,16";
    width = 440;

    backgroundColor = colors.withHashtag.base00;
    borderColor = colors.withHashtag.base0D;
    textColor = colors.withHashtag.base05;
    progressColor = "over ${colors.withHashtag.base02}";
    font = "${fonts.sansSerif.name} ${toString fontSizes.popups}";

    extraConfig = ''
      [urgency=low]
      background-color=${colors.withHashtag.base00}
      border-color=${colors.withHashtag.base0D}
      text-color=${colors.withHashtag.base0A}

      [urgency=high]
      background-color=${colors.withHashtag.base00}
      border-color=${colors.withHashtag.base0D}
      text-color=${colors.withHashtag.base08}

      [app-name="Slack"]
      group-by=summary
      default-timeout=15000
    '';
  };

  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 600;
        command = "${nixpkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 1200;
        command = "${nixpkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${nixpkgs.sway}/bin/swaymsg 'output * power on'";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${nixpkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };

  services.kanshi = {
    enable = true;
    profiles = {
      Home = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "6940,2160";
            scale = 1.0;
          }
          {
            criteria = "LG Electronics LG Ultra HD 0x00001B21";
            mode = "3840x2160@60Hz";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
            mode = "3840x2160@60Hz";
            position = "3840,0";
            scale = 1.0;
          }
        ];
      };
      Mobile = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "6940,2160";
            scale = 1.0;
          }
        ];
      };
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
    package = inputs.nixpkgs-wayland.packages.foot;
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
