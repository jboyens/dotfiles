# modules/dev/ruby.nix --- https://ruby-lang.org

{ config, options, lib, pkgs, ... }:
let
  cfg = config.modules.dev.ruby;
in
with lib;
{
  options.modules.dev.ruby = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ruby_2_7;
    };
  };

  config = mkIf cfg.enable {
    my = {
      packages = with pkgs; [
        ruby
      ];

      # Add the gem_path to bin, this is dependent on the version
      # the below MIGHT work better
      # env.PATH = [ "$(gem environment gemdir)/bin" ];
      env.PATH = [ "$HOME/.gem/ruby/${cfg.package.version.libDir}/bin" ];

      alias.bi = "bundle install";
      alias.be = "bundle exec";
      alias.pry = "bundle exec pry";
    };
  };
}
