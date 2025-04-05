{config, ...}: {
  networking.firewall = {
    allowedUDPPorts = [51806];
  };

  # Enable WireGuard
  networking.wireguard.interfaces = {
    wg0 = {
      # ips = ["172.16.6.6/24" "172.16.8.9/24" "10.255.4.0/24" "10.0.18.0/24" "10.0.16.0/22" "10.0.6.0/24" "10.0.0.0/15" "172.16.0.0/16"]; #"10.255.255.5/32" ]; # "10.100.0.2/24"
      listenPort = 51806;
      # privateKeyFile = config.age.secrets.wireguard.path;
      # privateKey = "EKS6xoRCmqOjlCcQpGlKyAZngzHfzjo1rzVAaFQpnUs=";
      # privateKey = "uECA1j8gD+87syVQ53sm2dJ5wYUoUf7VYwlDu4cUnkM=";
      # privateKey = "2IbLDiwZYK2OU2qb/6Otgz37TD24djfG+BQmQ/afY24=";
      # privateKey = "OG1eD6UibGzR/XY0ehiJbaH+QgYZzt2KgaJrCdJ35lE=";
      privateKey = "qB7TsJMZVkdLh2zTf1C+5SlH8t18zFI/E9DCmeevhHo=";
      ips = ["172.16.8.9/24"];

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
          # publicKey = "8iavDDd2G9P4BIpVly7Epk94Brdo9FJv/jXYA1Lmmw4=";
          # publicKey = "BojskYVtneuRXagGvShJFyjmVqk4shQWtoGfmAvl+gQ=";

          publicKey = "jkkMBmQbY4VI1/XHpLR2WRsvtEiqIPrOY8pKTaSCsD0=";
          allowedIPs = [
            "172.16.0.0/16"
            "10.0.6.0/24"
            "10.255.4.0/24"
            "10.0.16.0/22"
            "10.0.0.0/15"
            # "3.135.127.131/32"
            # "172.16.0.0/22"
            # "10.0.0.0/16"
            # "10.255.0.0/16"
            "3.128.238.143/32"
            "172.16.0.0/22"
            "10.0.0.0/16"
            "10.255.0.0/16"
            "10.255.0.0/16"
          ];
          persistentKeepalive = 10;
          # endpoint = "vpn.rust.energy:51806";
          # presharedKey = "yMvv1brtS3yjVoN+hJBksQE8SyHDIclR0mwBOVTwQxQ=";
          endpoint = "vpn.placebo-pharma.com:51804";
          # presharedKey = "Hyzo77nVQHwsfXSVXo5nfmbNEFPpT5whTE8ISbvdwmc=";
          # presharedKey = "iGYFNMeY8oFlM1jfa788AFHNaphroKamtx1alyMfzyw=";
          presharedKey = "nAwxgoUVCaIdzYvyo/dv79VPAqmk7LA4Ar7/K10RBmg=";
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
