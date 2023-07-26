{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (cell) lib;

  inherit (inputs.cells.homebase) nixosProfiles;
  styles = nixosProfiles.styles.config;

  inherit (styles.styling) colors fonts fontSizes;

  l = cell.lib // builtins;
in {
  imports = [
    (import ./__keybindings.nix {inherit inputs cell;})
    (import ./__window.nix {inherit inputs cell;})
    (import ./__waybar.nix {inherit inputs cell;})
    (import ./__colors.nix {inherit inputs cell;})
  ];

  # services = {xserver.enable = lib.mkDefault false;};

  home.packages = with nixpkgs; [
    autotiling
    fuzzel
    grim
    qt5.qtwayland
    sirula
    slurp
    sov
    sway-contrib.grimshot
    swaybg
    swayidle
    swaylock
    swayr
    wayvnc
    wev
    wl-clipboard
    wlr-randr
    wob
    wofi
    # my.swaywindow
  ];

  programs.swaylock = let
    inside = colors.base01-hex;
    outside = colors.base01-hex;
    ring = colors.base05-hex;
    text = colors.base05-hex;
    positive = colors.base0B-hex;
    negative = colors.base08-hex;
  in {
    enable = true;
    settings = {
      color = outside;
      scaling = "fill";
      inside-color = inside;
      inside-clear-color = inside;
      inside-caps-lock-color = inside;
      inside-ver-color = inside;
      inside-wrong-color = inside;
      key-hl-color = positive;
      layout-bg-color = inside;
      layout-border-color = ring;
      layout-text-color = text;
      line-uses-inside = true;
      ring-color = ring;
      ring-clear-color = negative;
      ring-caps-lock-color = ring;
      ring-ver-color = positive;
      ring-wrong-color = negative;
      separator-color = "00000000";
      text-color = text;
      text-clear-color = text;
      text-caps-lock-color = text;
      text-ver-color = text;
      text-wrong-color = text;

      image = l.toString styles.styling.image;
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
      export XCURSOR_PATH=${nixpkgs.paper-icon-theme}/share/icons
      export XCURSOR_THEME=Paper
      export LIBVA_DRIVER_NAME=iHD
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
        "*" = {bg = "/home/jboyens/Downloads/vhs.png fill";};

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

      workspaceOutputAssign = [
        {
          output = "eDP-1";
          workspace = "1";
        }
        {
          output = "LG Electronics LG Ultra HD 0x00011A21";
          workspace = "2";
        }
        {
          output = "Philips Consumer Electronics Company PHL 272P7VU 0x0000014E";
          workspace = "3";
        }
      ];

      bars = [];

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
          command = "${nixpkgs.autotiling}/bin/autotiling";
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
      themes = ["Paper" "Paper-Mono-Dark" "Adwaita" "hicolor"];
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

  services.mpris-proxy.enable = true;

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
      package = nixpkgs.adw-gtk3;
      name = "adw-gtk3";
    };
  };

  # services.udev.extraRules = ''
  #   KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  # '';
}
