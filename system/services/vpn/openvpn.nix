{ pkgs, ... }:

{
  services.openvpn.servers = {
    nordVPN = {
      config = '' config ${ ./us9361.nordvpn.com.tcp443.ovpn } '';
    };
  };
}
