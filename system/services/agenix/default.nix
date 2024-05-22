{ config, pkgs, ...}:

{
  imports = [ <agenix/modules/age.nix> ];
  environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];

  age.secrets.nuwave = {
    file = ./secrets/NUwave.age;
    owner = "cajun";
  };

  age.secrets.wireguard = {
    file = ./secrets/wireguard.age;
    owner = "cajun";
  };

  age.secrets.rmfakecloud-env = {
    file = ./secrets/rmfakecloud-env.age;
    owner = "cajun";
  };

  age.secrets."rmfakecloud-https.key" = {
    file = ./secrets/rmfakecloud-https.key.age;
    owner = "cajun";
  };

  age.secrets."rmfakecloud-https.crt" = {
    file = ./secrets/rmfakecloud-https.crt.age;
    owner = "cajun";
  };

  age.identityPaths = [ "/home/cajun/.ssh/id_ed25519" ];
}
