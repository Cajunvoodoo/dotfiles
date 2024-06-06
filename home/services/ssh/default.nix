{pkgs, ...}: {
  programs.ssh = {
    enable = true;
    #package = pkgs.libsForQt5.ksshaskpass;
  };
}
