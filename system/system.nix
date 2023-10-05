{ config, pkgs, ...}:

{
  imports = [
    ./services/services.nix
    ./wm/xmonad.nix
    ./hardware/hardware.nix
    ./programs/programs.nix
  ];
}
