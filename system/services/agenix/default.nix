{
  inputs,
  config,
  pkgs,
  ...
}: {
  # imports = [ <agenix/modules/age.nix> ];
  imports = [inputs.agenix.nixosModules.default];
  # environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];
  environment.systemPackages = [inputs.agenix.packages.x86_64-linux.default];

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

  age.secrets.nordvpn-token = {
    file = ./secrets/nordvpn-token.age;
    owner = "cajun";
  };

  # age.secrets.spotify = {
  #   file = ./secrets/spotify.age;
  #   owner = "cajun";
  #   group = "users";
  #   mode = "770";
  # };

  # Binary Ninja tar file, to avoid leaking it to the public
  # age.secrets."binary-ninja.tar.gz" = {
  #   file = ./secrets/binary-ninja.tar.gz.age;
  #   owner = "cajun";
  # };

  # age.secrets."rcu.tar.gz" = {
  #   file = ./secrets/rcu.tar.gz.age;
  #   owner = "cajun";
  # };

  age.identityPaths = ["/home/cajun/.ssh/id_ed25519"];
}
