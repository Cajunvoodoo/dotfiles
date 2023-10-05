{ pkgs,... }:

{
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [
      "wlp0s20f3"
    ];
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  users.users.cajun.extraGroups = [ "libvirtd" ];

  # TODO: move this elsewhere
  networking.bridges = {
    "br0" = {
      interfaces = [
        "wlp0s20f3"
      ];
    };
  };

  # networking.interfaces.wlp0s20f3.proxyARP = true;
}
