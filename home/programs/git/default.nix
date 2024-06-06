{
  config,
  pkgs,
  ...
}: {
  home.file.".ssh/allowed_signers".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILW6BE298UYhCRPh5nkCsWfAuDlouCoZE83JRR80dEan Cajunvoodoo GitHub Signing Key";
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
      rebase.updateRefs = true;
    };
  };
}
