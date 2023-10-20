{ config, pkgs, ...}:

{
  home.file.".ssh/allowed_signers".text =
    "* ${builtins.readFile /home/cajun/.ssh/github_cajun_signing.pub}";

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Cajunvoodoo";
    userEmail = "27892784+Cajunvoodoo@users.noreply.github.com";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "/home/cajun/.ssh/allowed_signers";
      user.signingkey = "/home/cajun/.ssh/github_cajun_signing.pub";
    };
  };
}
