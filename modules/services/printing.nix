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
      drivers = with pkgs; [ my.hll2350dw-cups ];
    };

    hardware.printers = {
      ensureDefaultPrinter = "HLL2350DW";
      ensurePrinters = [{
        name = "HLL2350DW";
        deviceUri = "socket://192.168.86.39:9100";
        model = "brother-HLL2350DW-cups-en.ppd";
        ppdOptions = {
          PageSize = "Letter";
          MediaType = "PLAIN";
          Resolution = "600dpi";
          InputSlot = "TRAY1";
          Duplex = "DuplexNoTumble";
          TonerSaveMode = "OFF";
        };
      }];
    };
  };
}
