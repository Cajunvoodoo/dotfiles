{pkgs, ...}:

{
  imports = [
    #./textEditors/neovim.nix
    #./textEditors/emacs/main.nix
    ./programs/programs.nix
    ./services/services.nix
  ];
  home = { stateVersion = "23.05"; };

  fonts.fontconfig = {
    enable = true;
  };

  #gtk = {
    #enable = true;
    #font.name = "Iosevka";
    #font.size = 14;
    #theme.package = pkgs.dracula-theme;
    #theme.name = "Dracula";
  #};

#  home.file = {
#    eww = {
#      source = ./other/eww;
#      recursive = true;
#      target = "./.config/eww/";
#    };
#
#  };

  programs.alacritty = {
    enable = true;
#    settings = {
#      main = {
#        term = "xterm-256color";
#        font = "Iosevka:size=14";
#        dpi-aware = "yes";
#      };
#      mouse = {
#        hide-when-typing = "yes";
#                        };
#                        colors = {
#                          background = "0x282a36";
#                        };
#    };
  };
}
 
