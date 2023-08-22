{ config, pkgs, ...}:

{
  programs.home-manager.enable = true;

  imports = [
     ./xmonad/default.nix
     ./rofi/default.nix
     ./fish/default.nix
     ./git/default.nix
     ./doom-emacs/default.nix
  ];
}
