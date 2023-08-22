{ config, pkgs, ...}:

{
  imports = [
    ./yubico/default.nix
    ./udev/default.nix
    ./agenix/default.nix
  ];
}
