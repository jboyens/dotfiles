# modules/desktop/term/alacritty.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty = {enable = mkBoolOpt false;};

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = alacritty ] && export TERM=xterm-256color
    '';

    home.programs.alacritty.enable = true;
    home.programs.alacritty.settings = {
      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };

        decorations = "none";

        start_mode = "Windowed";

        dynamic_title = true;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      mouse_bindings = [
        {
          mouse = "Middle";
          action = "PasteSelection";
        }
      ];

      mouse = {
        double_click = {threshold = 300;};
        triple_click = {threshold = 300;};

        hide_when_typing = false;
      };

      hints = {
        mouse = {
          enabled = true;
          mods = "None";
        };
      };

      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>";
        save_to_clipboard = false;
      };

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      live_config_reload = true;
      working_directory = "None";
    };

    user.packages = with pkgs; [alacritty];
  };
}
