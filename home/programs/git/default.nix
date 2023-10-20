{ config, pkgs, ...}:

{
  home.file.".ssh/allowed_signers".text =
    "* ${builtins.readFile /home/cajun/.ssh/id_ed25519.pub}";

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Cajunvoodoo";
    userEmail = "27892784+Cajunvoodoo@users.noreply.github.com";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/github_cajun_signing.pub";
    };
  };
}
