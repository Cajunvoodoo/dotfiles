{ config, pkgs, ...}:

{
  imports = [
     # Security
     ./gpg-agent/default.nix
     ./ssh/default.nix

     # Desktop config
     ./pasystray/default.nix
     ./blueman-applet/default.nix
     ./nm-applet/default.nix
     ## Compositor
     ./picom/default.nix

     # Music
     ./music/music.nix
  ];
}
