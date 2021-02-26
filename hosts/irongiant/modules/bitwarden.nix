{ config, lib, ... }:

{
  modules.services.bitwarden.enable = true;

  services.bitwarden_rs.config = {
    signupsAllowed = false;
    invitationsAllowed = true;
    domain = "https://bw.fooninja.org";
    httpPort = 8000;
  };

  # Inject secrets at runtime
  systemd.services.bitwarden_rs.serviceConfig = {
    EnvironmentFile = [ config.age.secrets.bitwarden-smtp-env.path ];
    Restart = "on-failure";
    RestartSec = "2s";
  };
}
