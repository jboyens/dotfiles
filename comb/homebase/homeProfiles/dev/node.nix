{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  node = nixpkgs.nodejs_latest;
in {
  home = {
    packages = [
      node
      nixpkgs.yarn
    ];

    # Run locally installed bin-script, e.g. n coffee file.coffee
    shellAliases = {
      n = "PATH=\"$(${node}/bin/npm bin):$PATH\"";
      ya = "yarn";
    };

    sessionVariables = {
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
      NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";
    };

    sessionPath = ["$(${nixpkgs.yarn}/bin/yarn global bin)"];

    file.".config/npm/config".text = ''
      cache=$XDG_CACHE_HOME/npm
      prefix=$XDG_DATA_HOME/npm
    '';
  };
}
