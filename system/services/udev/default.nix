{ config, pkgs, ...}:

{
  services.udev = {
    packages = [ pkgs.yubikey-personalization ];
  };

  # Adds a udev rule allowing users in the video group to modify backlight
  programs.light.enable = true;

  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  # '';

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
