{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.wireguard;
in {
  options.modules.services.wireguard = {
    enable = mkBoolOpt false;
    server.enable = mkBoolOpt false;
    client.enable = mkBoolOpt false;
  };

  config = mkMerge [
    ({ user.packages = with pkgs; [ wireguard ]; })
    (mkIf cfg.server.enable {
      networking.nat.enable = true;
      networking.nat.externalInterface = "enp0s20u1";
      networking.nat.internalInterfaces = [ "wg0" ];
      networking.firewall = { allowedUDPPorts = [ 51820 ]; };

      networking.wireguard.interfaces = {
        wg0 = {
          ips = [ "10.100.0.1/24" ];
          listenPort = 51820;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';

          # This undoes the above command
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';

          privateKeyFile =
            "/home/jboyens/.secrets/wireguard/irongiant/private.key";
          peers = [{
            publicKey = "jGoS2hb7yLIg9OEhl7xSCid790yiREjO4lk36m2pVAA=";
            allowedIPs = [ "10.100.0.2/32" ];
          }];
        };
      };
    })
  ];
}
