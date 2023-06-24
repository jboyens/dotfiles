{
  programs.system-config-printer.enable = true;

  services.printing = {
    enable = true;
  };

  hardware.printers = {
    ensureDefaultPrinter = "HLL2350DW";
    ensurePrinters = [
      {
        name = "HLL2350DW";
        deviceUri = "ipp://192.168.86.39";
        model = "everywhere";
        ppdOptions = {
          PageSize = "Letter";
          Duplex = "DuplexNoTumble";
        };
      }
    ];
  };
}
