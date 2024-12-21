{
  config,
  pkgs,
  ...
}: {
  services.udev = {
    packages = [pkgs.yubikey-personalization];
  };

  # Adds a udev rule allowing users in the video group to modify backlight
  programs.light.enable = true;

  # Disable laptop's camera, which hogs battery/power
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="5986", ATTR{idProduct}=="9102", ATTR{authorized}="0"
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
