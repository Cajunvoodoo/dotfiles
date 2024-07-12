{pkgs, ...}: {
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  environment.systemPackages = with pkgs; [
    powertop
  ];
}
