{ config, pkgs, ...}:

{
  programs.home-manager.enable = true;

  imports = [
      # Desktop
     ./xmonad/default.nix
     ./polybar/default.nix
     ./xmobar/default.nix
     ./rofi/default.nix
      # Shell
     ./fish/default.nix
      # Tools
     ./git/default.nix
     ./direnv/default.nix
     # Editor
     ./doom-emacs/default.nix
     # Misc
     ./feh/default.nix
  ];
}
