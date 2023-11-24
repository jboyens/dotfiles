{cell, ...}: let
  inherit (cell) pkgs;
in {
  # tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #   };
  # };
  services.auto-cpufreq = {
    enable = true;
  };
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "jboyens";
    configDir = "/home/jboyens/.config/syncthing";
    dataDir = "/home/jboyens/.local/share/syncthing";
  };
  hardware.printers = {
    ensureDefaultPrinter = "HLL2350DW";
    ensurePrinters = [
      {
        name = "HLL2350DW";
        deviceUri = "ipp://192.168.86.78";
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
        };
      }
    ];
  };
  services.system-config-printer.enable = true;
  services.printing = {
    enable = true;
  };
  hardware.keyboard.zsa.enable = true;
  programs.adb.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.solo2-cli
  ];

  # Clean up leftovers, as much as we can
  system.userActivationScripts.cleanupHome = ''
    pushd "/home/jboyens"
    rm -rf .compose-cache .nv .pki .dbus .fehbg
    [ -s .xsession-errors ] || rm -f .xsession-errors*
    popd
  '';
  # even though this is managed via home-manager, this sets up some pam stuff
  # that is important
  programs.sway = {
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
      export XCURSOR_PATH=${pkgs.dracula-icon-theme}/share/icons
      export XCURSOR_THEME=Dracula
      export WLR_DRM_NO_MODIFIERS=1
    '';
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    wlr.settings = {
      screencast = {
        output_name = "DP-4";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
  };
  # extraPortals = with pkgs; [xdg-desktop-portal-gtk];

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.udevil.enable = true;
  programs.dconf.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  services.atd.enable = true;

  services.dbus.packages = [pkgs.gcr];
  services.upower.enable = true;

  programs.hyprland = {
    enable = true;
  };
}
