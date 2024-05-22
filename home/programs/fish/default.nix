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

  home.packages = [ pkgs.oh-my-fish ];

  programs.fish = {
    enable = true;

    plugins = [
      fzf
      theme-dmorrell
    ];

    shellAliases = {
      rebuild = "rm -f ~/.gtkrc-2.0 ~/.config/gtk-4.0/settings.ini ~/.config/gtk-4.0/gtk.css ~/.config/gtk-3.0/settings.ini ~/.xmonad/xmonad-x86_64-linux && sudo nixos-rebuild switch";
    };

    interactiveShellInit = ''
      source ${theme-dmorrell.src}/fish_prompt.fish
      source ${theme-dmorrell.src}/fish_right_prompt.fish
      fish_add_path ${config.xdg.configHome}/emacs/bin
      set -g fish_greeting

      # Mutli-cd, from the fish documentation.
      # Transforms multiple pairs of `..` into `cd ../`, so .. = 1 dir back,
      # and progressive `.` add another dir (into another `/../`)
      # .... turns into `cd ../../../`
      function multicd
          echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
      end
      abbr --add dotdot --regex '^\.\.+$' --function multicd

      # Turn nfs into `nix flake show --allow-import-from-derivation`
      abbr --add nfs nix flake show --allow-import-from-derivation

      # Make "direnv reload" quicker to type
      abbr --add reload direnv reload

      # "gitzip" quickly zips up a git repo
      abbr --add gitzip git archive --format=zip --output submission.zip master

      # Working on windows systems results in bad habits
      abbr --add ipconfig ifconfig
    '';
  };
}
