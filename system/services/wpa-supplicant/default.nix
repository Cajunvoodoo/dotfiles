{ config, ... }:

{
  imports =
    [
      <agenix/modules/age.nix>
      # ../agenix/secrets.nix
    ];

  nixpkgs.config.packageOverrides = pkgs: rec {
    wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
      patches = attrs.patches ++ [ ./eduroam.patch ];
    });
  };

  networking = {
    networkmanager.enable = true;

    wireless = {
      enable = false;
      userControlled.enable = true;

      environmentFile = config.age.secrets.nuwave.path;

      networks = {
        "NUwave" = {
          hidden = false;

          auth = ''
            key_mgmt=WPA-EAP
            eap=PEAP
            phase1="peaplabel=0"
            phase2="auth=MSCHAPV2"
            identity="dwyer.t"
            password="@password@"
          '';
        };

        "bruh" = {
          hidden = false;

          auth = ''
            a
          '';
        };
      };
    };


    hostName = "cajun";
  };
}
