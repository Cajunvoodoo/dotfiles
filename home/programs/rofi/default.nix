{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.wezterm}/bin/wezterm";
    theme = ./theme.rafi;
  };
}
