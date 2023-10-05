{ config, lib, pkgs, ...}:

{
  # Xmonad config
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;

      #extraLayouts.us-custom = {
        #description = "US layout with custom hyper keys";
        #languages   = [ "eng" ];
        #symbolsFile = ./us-custom.xkb;
      #};

      layout = "us";

      videoDrivers = [ "nvidia" ];

      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          naturalScrolling = true;
        };
      };

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      displayManager = {
        defaultSession = "none+xmonad";
	sddm.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      # does not work, setting it manually on start up
      xkbOptions = "ctrl:nocaps";

    };
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
   };
  };

  services.blueman.enable = true;

  systemd.services.upower.enable = true;

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
