{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.printing;
in {
  options.modules.services.printing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
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
