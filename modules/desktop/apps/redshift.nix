# modules/desktop/apps/redshift.nix

{ config, lib, pkgs, ... }:
{
  services.redshift.enable = true;

  # For redshift
  location = (if config.time.timeZone == "America/Los_Angeles" then {
    latitude = 47.6062;
    longitude = -122.3321;
  } else if config.time.timeZone == "Europe/Copenhagen" then {
    latitude = 55.88;
    longitude = 12.5;
  } else {});
}
