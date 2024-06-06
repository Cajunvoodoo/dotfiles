{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    udevil
  ];
  programs.udevil.enable = true;
  services.devmon.enable = true;

  systemd.user.services.devmon = {
    enable = true;
    reloadIfChanged = true;
    wantedBy = pkgs.lib.mkForce ["default.target"];
  };
}
