{ config, lib, pkgs, ...}:

{
  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";

      videoDrivers = [ "nvidia" ];

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };
      
      windowManager.xmonad = {
        enable = false;
        enableContribAndExtras = true;
      };
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  #enable in case display is not found during boot
  #boot.kernelParams = [ "module_blacklist=i915"; ];
}
