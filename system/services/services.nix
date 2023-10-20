{ config, pkgs, ...}:

{
  imports = [
    ./agenix/default.nix
    ./automount/default.nix
    ./udev/default.nix
    ./wpa-supplicant/default.nix
    ./yubico/default.nix
    # ./openvpn/default.nix
    ./keyboard/intercept.nix
  ];
}
