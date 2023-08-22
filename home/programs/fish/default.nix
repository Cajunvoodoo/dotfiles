{ config, pkgs, lib, ...}:

let
  fzf = {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner  = "PatrickF1";
      repo   = "fzf.fish";
      rev    = "refs/tags/v9.9";
      sha256 = "Aqr6+DcOS3U1R8o9Mlbxszo5/Dy9viU4KbmRGXo95R8=";
    };
  };
  theme-dmorrell = {
    name = "theme-dmorrell";
    src = pkgs.fetchFromGitHub {
      owner  = "reitzig";
      repo   = "theme-dmorrell";
      rev    = "9c3bad91e8ee59a4616491fe5af199519420a718";
      sha256 = "QQtsgf6sQwb0I92I8LQGhkLEZlloURDiOa+oBgnphd0=";
    };
  };
in
{
  #import the fish dependencies
  imports = [
    ./fd/default.nix
    ./bat/default.nix
    ./fzf/default.nix
  ];
  
  #not in home manager for some reason
  home.packages = [ pkgs.oh-my-fish ];

  programs.fish = {
    enable = true;
    
    plugins = [
      fzf  
      theme-dmorrell
    ];
    
    interactiveShellInit = ''
      source ${theme-dmorrell.src}/fish_prompt.fish
      source ${theme-dmorrell.src}/fish_right_prompt.fish
      fish_add_path ${config.xdg.configHome}/emacs/bin
    '';
  };
}
