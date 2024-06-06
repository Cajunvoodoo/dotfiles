{config, ...}: {
  networking.firewall = {
    allowedUDPPorts = [51806];
  };

  # Enable WireGuard
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["172.16.6.6/24" "10.0.6.0/24" "10.0.0.0/15" "172.16.0.0/16"]; #"10.255.255.5/32" ]; # "10.100.0.2/24"
      listenPort = 51806;
      # privateKeyFile = config.age.secrets.wireguard.path;
      # privateKey = "EKS6xoRCmqOjlCcQpGlKyAZngzHfzjo1rzVAaFQpnUs=";
      # privateKey = "uECA1j8gD+87syVQ53sm2dJ5wYUoUf7VYwlDu4cUnkM=";
      # address = [ "172.16.6.6/24" ];
      privateKey = "2IbLDiwZYK2OU2qb/6Otgz37TD24djfG+BQmQ/afY24=";

      peers = [
        #   # CPTC VPN
        #   {
        #     publicKey = "D03qQS+3/+OH8EOCEwzVz9keNA82SZzYVlnokJBmJFA=";
        #     allowedIPs = [ "10.0.254.0/24" ]; # "0.0.0.0/0"

        #     endpoint = "129.21.249.92:51820";

        #     persistentKeepalive = 25;
        #   }
        {
          # publicKey = "VAj5vUgAGi3npdSplDlUFWMrcxbUqFPrj8W9cX0AbR4=";
          publicKey = "8iavDDd2G9P4BIpVly7Epk94Brdo9FJv/jXYA1Lmmw4=";
          allowedIPs = ["172.16.0.0/16" "10.0.6.0/24" "10.0.0.0/15"];
          persistentKeepalive = 10;
          # endpoint = "vpn.rust.energy:51806";
          # presharedKey = "yMvv1brtS3yjVoN+hJBksQE8SyHDIclR0mwBOVTwQxQ=";
          endpoint = "3.131.53.92:51806";
          presharedKey = "Hyzo77nVQHwsfXSVXo5nfmbNEFPpT5whTE8ISbvdwmc=";
          #[Interface]
          # PrivateKey = uECA1j8gD+87syVQ53sm2dJ5wYUoUf7VYwlDu4cUnkM=
          # Address = 172.16.6.6/24
          # DNS = 172.16.0.2

          # [Peer]
          # PublicKey = VAj5vUgAGi3npdSplDlUFWMrcxbUqFPrj8W9cX0AbR4=
          # PresharedKey = yMvv1brtS3yjVoN+hJBksQE8SyHDIclR0mwBOVTwQxQ=
          # AllowedIPs = 172.16.0.0/16,10.0.6.0/24
          # PersistentKeepalive = 0
          # Endpoint = vpn.rust.energy:51806
          #
        }
      ];
    };
  };
}
