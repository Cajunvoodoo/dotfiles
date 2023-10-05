{ config, pkgs, ...}:

{
  imports = [ <agenix/modules/age.nix> ];
  environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];

  age.secrets.nuwave = {
    file = ./secrets/NUwave.age;
    owner = "cajun";
  };

  age.identityPaths = [ "/home/cajun/.ssh/id_ed25519" ];
}
