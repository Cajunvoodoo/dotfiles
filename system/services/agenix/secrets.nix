let
  cajun = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG95H6L3N+gXc6JFj5Gyr0uvl5AfzhBdbUj8l3gUWbiq";
in {
  imports = [<agenix/modules/age.nix>];

  "github.age".publicKeys = [cajun];

  "nuwave.age".publicKeys = [cajun];

  "wireguard.age".publicKeys = [cajun];

  "rmfakecloud-env.age".publicKeys = [cajun];

  "rmfakecloud-https.key.age".publicKeys = [cajun];

  "rmfakecloud-https.crt.age".publicKeys = [cajun];

  "nordvpn-token.age".publicKeys = [cajun];
  # "binary-ninja.tar.gz.age".publicKeys = [cajun];
  # "rcu.tar.gz.age".publicKeys = [cajun];
}
