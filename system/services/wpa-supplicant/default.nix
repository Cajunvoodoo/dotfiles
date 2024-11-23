{
  inputs,
  config,
  ...
}: {
  # imports =
  #   [
  #     <agenix/modules/age.nix>
  #     # ../agenix/secrets.nix
  #   ];

  # nixpkgs.config.packageOverrides = pkgs: rec {
  #   wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
  #     patches = attrs.patches ++ [ ./eduroam.patch ];
  #   });
  # };

  networking = {
    networkmanager.enable = true;
    wireless = {
      extraConfig = ''
        openssl_ciphers=DEFAULT@SECLEVEL=0
      '';

      enable = false;
      userControlled.enable = true;

      secretsFile = config.age.secrets.nuwave.path;

      networks = {
      };
    };

    hostName = "cajun";
  };
}
