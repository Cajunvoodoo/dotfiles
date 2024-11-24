{
  config,
  lib,
  pkgs,
  ...
}: {
  # Xmonad config
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    displayManager = {
      defaultSession = "none+xmonad";
      # TODO: ssdm theming
      sddm.enable = true;
    };

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    xserver = {
      enable = true;
      autoRepeatDelay = 250; # 250ms is roughly equal to the shortest Windows delay

      videoDrivers = ["nvidia"];

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      # does not work, setting it manually on start up
      xkb = {
        options = "ctrl:nocaps";
        layout = "us";
      };
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

  boot.initrd.kernelModules = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = true;
    };
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    # driSupport = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];

    extraPackages32 = pkgs.lib.mkForce [
      pkgs.linuxPackages_latest.nvidia_x11.lib32
    ];
  };

  #enable in case display is not found during boot
  #boot.kernelParams = [ "module_blacklist=i915"; ];
}
