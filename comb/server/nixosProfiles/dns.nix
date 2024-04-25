{
  inputs,
  cell,
}: {
  # services.dnsmasq = {
  #   enable = true;
  #
  #   settings = {
  #     listen-address = "10.10.0.1";
  #     bind-interfaces = true;
  #
  #     interface = "enp0s13f0u3";
  #     domain = "fooninja.org";
  #     dhcp-option = [
  #       "3,10.10.0.1"
  #       "6,10.10.0.1"
  #       "121,192.168.86.0/24,10.10.0.1"
  #     ];
  #     dhcp-range = ["10.10.0.128,10.10.0.254,12h"];
  #     dhcp-authoritative = true;
  #   };
  # };

  # networking.nat = {
  #   enable = true;
  #   enableIPv6 = true;
  #   internalInterfaces = ["enp0s13f0u3"];
  #   externalInterface = "wlan0";
  # };
  #
  # networking.firewall = {
  #   trustedInterfaces = ["enp0s13f0u3"];
  #   interfaces.enp0s13f0u3.allowedUDPPorts = [53];
  # };
}
