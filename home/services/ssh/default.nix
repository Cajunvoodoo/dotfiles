{pkgs, ...}: {
  programs.ssh = {
    enable = true;
    # Host warhead
    #   HostName warhead.ccs.neu.edu
    #   Port 10001
    #   IdentityFile ~/.ssh/hacker96
    #   User hacker97
    extraConfig = ''
      IdentityFile ~/.ssh/hacker96
      IdentityFile ~/.ssh/desktop_ed25519
      IdentityFile ~/.ssh/id_ed25519
    '';
    #package = pkgs.libsForQt5.ksshaskpass;
  };
}
