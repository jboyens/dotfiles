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
      drivers = with pkgs; [ my.hll2350dw ];
    };

    hardware.printers = {
      ensureDefaultPrinter = "HLL2350DW";
      ensurePrinters = [{
        name = "HLL2350DW";
        deviceUri = "socket://192.168.86.39:9100";
        model = "brother-HLL2350DW-cups-en.ppd";
        ppdOptions = {
          Duplex = "DuplexNoTumble";
          PageSize = "Letter";
        };
      }];
    };
  };
}
