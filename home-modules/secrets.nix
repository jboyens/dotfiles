{
  inputs,
  config,
  ...
}: {
  imports = [inputs.agenix.homeManagerModules.default];

  config = {
    age = {
      identityPaths = [
        "${config.home.homeDirectory}/.ssh/id_ed25519"
        "${config.home.homeDirectory}/.ssh/id_rsa"
        "${config.home.homeDirectory}/.ssh/id_agenix_jboyens"
      ];
      secrets.pizauth.file = ./pizauth.conf.age;
    };
  };
}
