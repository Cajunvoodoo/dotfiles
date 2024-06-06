{pkgs, ...}: {
  imports = [
    #./textEditors/neovim.nix
    #./textEditors/emacs/main.nix
    ./programs/programs.nix
    ./services/services.nix
  ];
  xdg.userDirs.enable = true;
  home.homeDirectory = "/home/cajun";
  home = {stateVersion = "23.05";};

  fonts.fontconfig = {
    enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
  };

  #  home.file = {
  #    eww = {
  #      source = ./other/eww;
  #      recursive = true;
  #      target = "./.config/eww/";
  #    };
  #
  #  };

  programs.wezterm = {
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
