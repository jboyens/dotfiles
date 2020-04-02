# Alita -- my laptop

{ pkgs, config, ... }: {
  imports = [
    ../personal.nix # common settings
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/laptop/hdd>
    ./hardware-configuration.nix
    ## Apps
    # <modules/cloud.nix>
    <modules/db/postgres.nix>
    <modules/dev/node.nix>
    <modules/dev/podman.nix>
    <modules/shell/utils.nix>
  ];

  modules = {
    desktop = {
      bspwm.enable = true;

      apps.rofi.enable = true;
      apps.discord.enable = true;
      apps.vm.enable = true;

      term.default = "xst";
      term.st.enable = true;

      browsers.default = "firefox";
      browsers.firefox.enable = true;
      browsers.google-chrome.enable = true;
    };

    editors = {
      default = "emacs";
      emacs.enable = true;
      vim.enable = true;
    };

    media = {
      spotify.enable = true;
    };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      tmux.enable = true;
      ranger.enable = true;
      zsh.enable = true;
    };

    services = {
      syncthing.enable = true;
      ssh.enable = true;
    };

    themes.fluorescence.enable = true;
  };

  networking.useDHCP = true;
  networking.wireless.enable = true;
  networking.wireless.networks = { Sledgehammer = { psk = "nagasaki"; }; };

  services.xserver.libinput = {
    enable = true;
    tapping = true;
    clickMethod = "clickfinger";
  };
  services.blueman.enable = true;

  # services.xserver.exportConfiguration = true;
  services.xserver.xkbModel = "dell";
  services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";
  services.xserver.videoDrivers = [ "intel" "nouveau" ];
  i18n.consoleUseXkbConfig = true;

  services.thermald.enable = true;
  services.resolved.enable = true;
  services.resolved.dnssec = "false";
  services.irqbalance.enable = true;
  services.fstrim.enable = true;

  time.timeZone = "America/Los_Angeles";
  # time.timeZone = "Europe/Copenhagen";

  # Optimize power use
  environment.systemPackages = [
    pkgs.acpi
    pkgs.linuxPackages.cpupower
    # Respect XDG conventions, damn it!
    # (pkgs.writeScriptBin "nvidia-settings" ''
    #   #!${pkgs.stdenv.shell}
    #   mkdir -p "$XDG_CONFIG_HOME/nvidia"
    #   exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
    # '')
    pkgs.my.bosh-cli
    pkgs.my.bosh-bootloader
    pkgs.my.credhub-cli
    pkgs.my.logcli
    # pkgs.my.gmailctl
  ];

  services.psd.enable = true;

  services.lorri.enable = true;

  # Battery life!
  services.tlp.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = false;

  # systemd.services.dell-bios-fan-control = {
  #   enable = true;
  #   description = "Disable Dell BIOS Fan Control";
  #   wantedBy = ["multi-user.target" "graphical.target" "rescue.target" "fancontrol.service"];
  #   unitConfig = {
  #     Type = "oneshot";
  #   };
  #
  #   serviceConfig = {
  #     ExecStart = "${pkgs.my.dell-bios-fan-control}/bin/dell-bios-fan-control 0";
  #     Restart = "no";
  #   };
  # };

  systemd.services.fancontrol = {
    enable = true;
    description = "Fan control";
    wantedBy = [ "multi-user.target" "graphical.target" "rescue.target" ];

    unitConfig = { Type = "simple"; };

    serviceConfig = {
      ExecStart = "${pkgs.lm_sensors}/bin/fancontrol";
      Restart = "always";
    };
  };

  environment.etc.fancontrol = {
    text = ''
      INTERVAL=10
      DEVPATH=hwmon4=
      DEVNAME=hwmon4=dell_smm
      FCTEMPS=hwmon4/pwm1=hwmon4/temp1_input
      FCFANS= hwmon4/pwm1=hwmon4/fan1_input
      MINTEMP=hwmon4/pwm1=40
      MAXTEMP=hwmon4/pwm1=65
      MINSTART=hwmon4/pwm1=150
      MINSTOP=hwmon4/pwm1=150
      MINPWM=hwmon4/pwm1=150
    '';
    mode = "444";
  };

  # Monitor backlight control
  programs.light.enable = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;

  networking.wireguard.interfaces = {
    production = {
      ips = [ "10.50.0.3" ];
      privateKeyFile =
        "/home/${config.my.username}/.secrets/wireguard/production-private.key";
      listenPort = 51821;
      peers = [{
        publicKey = "3OapT30c5x8oxbVv/hmbZPjENRiUz17JtksDKcD6Lhs=";
        allowedIPs = [ "10.50.0.1/32" "10.8.0.0/16" ];
        endpoint = "52.175.216.108:51820";
        persistentKeepalive = 25;
      }];
    };

    interconnect = {
      ips = [ "10.10.0.3" ];
      privateKeyFile =
        "/home/${config.my.username}/.secrets/wireguard/interconnect-private.key";
      listenPort = 51820;
      peers = [{
        publicKey = "/RFIsNdpsxNma871IgNKgWJUwPg47EsUNR/uGm9vkE0=";
        allowedIPs = [
          "10.10.0.0/24"
          "10.16.0.0/24"
          "10.158.0.0/24"
          "10.74.0.0/24"
          "10.0.0.0/24"
          "10.32.0.0/24"
          "10.34.0.0/24"
          "10.148.0.0/24"
          "10.36.0.0/24"
        ];
        endpoint = "13.66.198.100:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  services.autorandr.enable = true;
  my.home.programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "restart-bspwm" = "${pkgs.bash}/bin/bash $XDG_CONFIG_HOME/bspwm/bspwmrc";
        "reset-background" =
          "${pkgs.feh}/bin/feh --no-fehbg --bg-fill ~/.background-image";
        "reset-keyboard" = ''
          if ${pkgs.xorg.xinput}/bin/xinput | grep "ErgoDox" 1>/dev/null; then
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap us -model dell -option ""
          else
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap dvorak -option "${config.services.xserver.xkbOptions}"
          fi
        '';
      };
    };
    profiles = {
      "mobile" = {
        hooks = {
          preswitch = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --primary";
        };
        fingerprint = {
          eDP1 =
            "00ffffffffffff0009e590060000000001190104952213780a24109759548e271e5054000000010101010101010101010101010101019c3b8010713850403020360058c11000001a2e2c80de703814406464440558c11000001a000000fe0043314a4652804e5431354e3431000000000000412196001000000a010a202000bb";
        };
        config = {
          eDP1 = {
            enable = true;
            primary = true;
            gamma = "1.0:0.909:0.833";
            mode = "1920x1080";
            position = "0x0";
            rate = "60.01";
          };
          HDMI1.enable = false;
          DP1.enable = false;
        };
      };

      "home" = {
        fingerprint = {
          HDMI1 =
            "00ffffffffffff001e6d085b211a01000a1c0103803c2278ea3035a7554ea3260f50542108007140818081c0a9c0d1c081000101010108e80030f2705a80b0588a0058542100001e04740030f2705a80b0588a0058542100001a000000fd00283d1e873c000a202020202020000000fc004c4720556c7472612048440a2001db020339714d902220050403020161605d5e5f230907076d030c001000b83c20006001020367d85dc401788003e30f0003681a00000101283d00023a801871382d40582c450058542100001a565e00a0a0a029503020350058542100001a00000000000000000000000000000000000000000000000000000000000000000000bb";
          eDP1 =
            "00ffffffffffff0009e590060000000001190104952213780a24109759548e271e5054000000010101010101010101010101010101019c3b8010713850403020360058c11000001a2e2c80de703814406464440558c11000001a000000fe0043314a4652804e5431354e3431000000000000412196001000000a010a202000bb";
        };
        config = {
          eDP1 = {
            enable = true;
            gamma = "1.0:0.909:0.833";
            mode = "1920x1080";
            position = "0x360";
            rate = "60.01";
          };

          HDMI1 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "2560x1440";
            rate = "30.00";
            gamma = "1.0:0.909:0.833";
          };

          DP1.enable = false;
        };
      };
    };
  };
}
