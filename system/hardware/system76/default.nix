{ pkgs, ... }:

{
  hardware.system76 = {
    # Note: no power daemon because the system76 power daemon is awful
    kernel-modules.enable = true;
    firmware-daemon.enable = true;
  };
}
