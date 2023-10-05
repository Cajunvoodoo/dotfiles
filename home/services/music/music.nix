{ config, pkgs, ...}:

{
  imports = [
    ./mpris/default.nix
    ./playerctl/default.nix
    ./mpd/default.nix
  ];
}
