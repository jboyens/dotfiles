# Kitt -- my work laptop

{ pkgs, config, ... }: {
  imports = [
    ../personal.nix # common settings
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/laptop/hdd>
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      bspwm.enable = true;

      apps = {
        rofi.enable = true;
        discord.enable = true;
        slack.enable = true;
        vm.enable = true;
        zoom.enable = true;
        dbeaver.enable = true;
      };

      term.default = "xst";
      term.st.enable = true;

      browsers = {
        default = "firefox";
        firefox.enable = true;
        google-chrome.enable = true;
        vivaldi.enable = true;
        qutebrowser.enable = true;
      };

      gaming = {
        steam.enable = true;
        factorio.enable = false;
        emulators = {
          psx.enable = false; # Playstation
          ds.enable = false; # Nintendo DS
          gb.enable = false; # GameBoy + GameBoy Color
          gba.enable = false; # GameBoy Advance
          snes.enable = false; # Super Nintendo
        };
      };

    };

    dev.node.enable = true;
    dev.cloud.google.enable = true;
    dev.podman.enable = true;

    editors = {
      default = "emacs";
      emacs.enable = true;
      vim.enable = true;
      vscode.enable = true;
    };

    email = { mu.enable = true; };

    media = { spotify.enable = true; };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      pass.enable = true;
      pgcenter.enable = true;
      tmux.enable = true;
      ranger.enable = true;
      zsh.enable = true;
      utils.enable = true;
    };

    services = {
      syncthing.enable = true;
      ssh.enable = true;
      docker.enable = true;
      calibre.enable = true;
    };

    themes.fluorescence.enable = true;
  };

  networking.useDHCP = true;
  networking.wireless.enable = true;
  networking.wireless.networks = {
    Sledgehammer = { psk = "nagasaki"; };
    FLEXE = { psk = "xxxxx"; };
  };

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
  console.useXkbConfig = true;

  services.thermald.enable = true;
  services.resolved.enable = true;
  services.irqbalance.enable = true;
  services.fstrim.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.my.hll2350dw ];

  hardware.printers.ensureDefaultPrinter = "HLL2350DW";
  hardware.printers.ensurePrinters = [{
    name = "HLL2350DW";
    deviceUri = "socket://192.168.86.29:9100";
    model = "brother-HLL2350DW-cups-en.ppd";
    ppdOptions = {
      Duplex = "DuplexNoTumble";
      PageSize = "Letter";
    };
  }];

  programs.system-config-printer.enable = true;

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
    pkgs.my.ferdi
    # pkgs.my.gmailctl
    pkgs.my."3mux"
    # pkgs.my.tanka
  ];

  services.psd.enable = true;
  services.upower.enable = true;
  services.lorri.enable = true;
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
  services.pcscd.enable = true;

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

  # systemd.services.fancontrol = {
  #   enable = true;
  #   description = "Fan control";
  #   wantedBy = [ "multi-user.target" "graphical.target" "rescue.target" ];
  #
  #   unitConfig = { Type = "simple"; };
  #
  #   serviceConfig = {
  #     ExecStart = "${pkgs.lm_sensors}/bin/fancontrol";
  #     Restart = "always";
  #   };
  # };
  #
  # environment.etc.fancontrol = {
  #   text = ''
  #     INTERVAL=10
  #     DEVPATH=hwmon4=
  #     DEVNAME=hwmon4=dell_smm
  #     FCTEMPS=hwmon4/pwm1=hwmon4/temp1_input
  #     FCFANS= hwmon4/pwm1=hwmon4/fan1_input
  #     MINTEMP=hwmon4/pwm1=40
  #     MAXTEMP=hwmon4/pwm1=65
  #     MINSTART=hwmon4/pwm1=150
  #     MINSTOP=hwmon4/pwm1=150
  #     MINPWM=hwmon4/pwm1=150
  #   '';
  #   mode = "444";
  # };

  # Monitor backlight control
  programs.light.enable = true;

  programs.iftop.enable = true;
  programs.iotop.enable = true;

  networking.wireguard.interfaces = { };

  services.autorandr.enable = true;
  my.home.programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        "restart-bspwm" =
          "${pkgs.bash}/bin/bash $XDG_CONFIG_HOME/bspwm/bspwmrc";
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
          postswitch =
            "${pkgs.pulseaudio}/bin/pactl set-card-profile output:analog-stereo+input:analog-stereo";
        };
        fingerprint = {
          eDP1 =
            "00ffffffffffff004d10ba1400000000161d0104a52213780ede50a3544c99260f505400000001010101010101010101010101010101ac3780a070383e403020350058c210000018000000000000000000000000000000000000000000fe004d57503154804c513135364d31000000000002410332001200000a010a202000d3";
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
          DP1.enable = false;
          DP2.enable = false;
          DP3.enable = false;
        };
      };

      "home" = {
        hooks = {
          postswitch =
            "${pkgs.pulseaudio}/bin/pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:hdmi-stereo-extra2+input:analog-stereo";
        };
        fingerprint = {
          DP3 =
            "00ffffffffffff001e6d085b211a01000a1c0103803c2278ea3035a7554ea3260f50542108007140818081c0a9c0d1c081000101010108e80030f2705a80b0588a0058542100001e04740030f2705a80b0588a0058542100001a000000fd00283d1e873c000a202020202020000000fc004c4720556c7472612048440a2001db020339714d902220050403020161605d5e5f230907076d030c001000b83c20006001020367d85dc401788003e30f0003681a00000101283d00023a801871382d40582c450058542100001a565e00a0a0a029503020350058542100001a00000000000000000000000000000000000000000000000000000000000000000000bb";
          eDP1 =
            "00ffffffffffff004d10ba1400000000161d0104a52213780ede50a3544c99260f505400000001010101010101010101010101010101ac3780a070383e403020350058c210000018000000000000000000000000000000000000000000fe004d57503154804c513135364d31000000000002410332001200000a010a202000d3";
        };
        config = {
          eDP1 = {
            enable = true;
            gamma = "1.0:0.909:0.833";
            mode = "1920x1080";
            position = "0x360";
            rate = "60.01";
          };

          DP3 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "2560x1440";
            rate = "30.00";
            gamma = "1.0:0.909:0.833";
          };

          DP1.enable = false;
          DP2.enable = false;
        };
      };
    };
  };
}
