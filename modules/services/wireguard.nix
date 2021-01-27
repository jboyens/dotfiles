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
      networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 51820 ];
      };

      services.dnsmasq = {
        enable = true;
        servers = [ "8.8.8.8" ];
        extraConfig = ''
          interface=wg0
          log-queries=extra
        '';
      };

      networking.wireguard.interfaces = {
        wg0 = {
          ips = [ "10.100.0.1/24" ];
          listenPort = 51820;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp0s20u1 -j MASQUERADE
          '';

          # This undoes the above command
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp0s20u1 -j MASQUERADE
          '';

          privateKeyFile =
            "/home/jboyens/.secrets/wireguard/irongiant/private.key";
          peers = [
            {
              publicKey = "jGoS2hb7yLIg9OEhl7xSCid790yiREjO4lk36m2pVAA=";
              allowedIPs = [ "10.100.0.2/32" ];
            }
            {
              publicKey = "cAnOtDzfBUL+c8Nu5Vc666JxcDfXkm/rIjo0Dh99LiA=";
              allowedIPs = [ "10.100.0.3/32" ];
            }
          ];
        };
      };
    })
    (mkIf cfg.client.enable {
      networking.wireguard.interfaces = {
        wg0 = {
          ips = [ "10.100.0.2/24" ];

          privateKeyFile = "/home/jboyens/.secrets/wireguard/kitt/private.key";
          peers = [{
            publicKey = "kxhD+BPEcgdK2N7KfZ/05QOhYtTMR0r8CccuYRpx8mc=";
            allowedIPs = [ "192.168.86.0/24" "10.100.0.0/24" ];
            endpoint = "bender.fooninja.org:51820";
            persistentKeepalive = 25;
          }];
        };
      };
    })
  ];
}
