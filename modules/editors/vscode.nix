{ config, options, lib, pkgs, ... }:

with lib; {
  options.modules.editors.vscode = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.vscode.enable {
    my = { packages = with pkgs; [ unstable.vscode ]; };
  };
}
