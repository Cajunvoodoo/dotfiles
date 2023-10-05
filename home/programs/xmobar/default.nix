{
  programs.xmobar = {
    enable = false;
    extraConfig = builtins.readFile ./xmobar0.hs;
  };
}
