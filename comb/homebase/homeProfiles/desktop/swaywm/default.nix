{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
in {
  imports = [
    (import ./__keybindings.nix {inherit inputs cell;})
    (import ./__window.nix {inherit inputs cell;})
  ];

  # services = {xserver.enable = lib.mkDefault false;};

  # TODO Move to nixosProfile
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   wlr.settings = {
  #     screencast = {
  #       output_name = "DP-4";
  #       max_fps = 30;
  #       chooser_type = "simple";
  #       chooser_cmd = "${nixpkgs.slurp}/bin/slurp -f %o -or";
  #     };
  #   };
  #   extraPortals = with nixpkgs; [xdg-desktop-portal-gtk];
  # };

  home.packages = with nixpkgs; [
    autotiling
    gammastep
    grim
    fuzzel
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

  programs.swaylock.enable = true;
  wayland.windowManager.sway = {
    enable = true;
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
    systemd.enable = true;
    config = {
      terminal = "${nixpkgs.foot}/bin/foot";

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
    extraConfig = ''
      [app-name="Slack"]
      group-by=summary
    '';
  };

  services.mpris-proxy.enable = true;
  wayland.windowManager.sway.swaynag.enable = true;

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

  # services.udev.extraRules = ''
  #   KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  # '';
}
