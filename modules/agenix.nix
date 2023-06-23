# modules/agenix.nix -- encrypt secrets in nix store
{
  options,
  config,
  lib,
  ...
}:
with builtins;
with lib; let
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  age = {
    secrets =
      if pathExists secretsFile
      then
        mapAttrs' (n: _:
          nameValuePair (removeSuffix ".age" n) {
            file = "${secretsDir}/${n}";
            owner = mkDefault config.user.name;
          }) (import secretsFile)
      else {};
    identityPaths =
      options.age.identityPaths.default
      ++ (filter pathExists [
        "${config.user.home}/.ssh/id_ed25519"
        "${config.user.home}/.ssh/id_rsa"
      ]);
  };
}
