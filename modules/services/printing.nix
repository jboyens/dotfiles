{ config, lib, pkgs, ... }:

with lib; {
  options.modules.services.printing = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.printing.enable {
    programs.system-config-printer.enable = true;

    services.printing = {
      enable = true;
      drivers = with pkgs; [ brlaser ];
    };

    hardware.printers = {
      ensureDefaultPrinter = "HLL2350DW";
      ensurePrinters = [{
        name = "HLL2350DW";
        deviceUri = "socket://192.168.86.39:9100";
        model = "drv:///brlaser.drv/br1200.ppd";
      }];
    };
  };
}
