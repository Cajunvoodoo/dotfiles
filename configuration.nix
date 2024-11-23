# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  variables,
  config,
  pkgs,
  lib,
  ...
}: let
  # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
  # nh = import (builtins.fetchTarball "https://github.com/viperML/nh/archive/master.tar.gz");
  # nixd = import (builtins.fetchTarball "https://github.com/nix-community/nixd/archive/refs/tags/2.0.2.tar.gz");
  # xmonad-config = (import /home/cajun/Projects/Haskell/xmonad-flake).nixosModules;
in {
  imports = [
    #include system configuration, which does not rely on home-manager
    ./system/system.nix
    # <home-manager/nixos>
    # nix-gaming.nixosModules.pipewireLowLatency
    # (nh.nixosModules)
  ];

  # nixpkgs.overlays = [
  #   (self: super: {
  #     cajun-xmonad = (builtins.getFlake "/home/cajun/Projects/Haskell/xmonad-flake").nixosModules.default;
  #   })
  #   # (newPkg: oldPkgs: {
  #   #   haskellPackages = oldPkgs.haskellPackages.override (old: {
  #   #     overrides = oldPkgs.lib.composeExtensions (old.overrides or (_: _: {  }))
  #   #       (self: super: {
  #   #         cajun-xmonad = self.callCabal2nix "cajun-xmonad" /home/cajun/Projects/Haskell/xmonad-flake {};
  #   #       });
  #   #   });
  #   # })
  # ];

  # cajun.desktop.wm = {
  #   enable = true;
  # };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      trusted-users = ["@wheel"];
    };
    nixPath = [
      # "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixpkgs=${inputs.nixpkgs}" # FLAKE, NIXD
      #FIXME: make this dependent on a variable instead of strictly cajun
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  documentation.nixos.enable = true;
  documentation.man.generateCaches = false;

  # Use the latest kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Deal with the consequences of using the latest kernel
  # boot.crashDump.enable = true;

  # Enables NixOS to compile and run software for these systems using
  # qemu emulation.
  # TODO: add packages that are useful (e.g. the dynamic loaders, other such things)
  #       to the binfmt dependencies
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "x86_64-windows"
    "riscv64-linux"
    "i686-linux"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-d89b562b-2f43-4f4e-b811-f712bec9c992".device = "/dev/disk/by-uuid/d89b562b-2f43-4f4e-b811-f712bec9c992";
  boot.initrd.luks.devices."luks-d89b562b-2f43-4f4e-b811-f712bec9c992".keyFile = "/crypto_keyfile.bin";

  # networking.hostName = "cajun"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireguard.enable = true;

  # required for MagicDNS to work
  services.resolved.enable = true;
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  services.tailscale = {
    enable = true; # Currently disabled to save battery life (too many wakeups per second)
    openFirewall = true;
    useRoutingFeatures = "both";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["cajun"];
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.dconf.enable = true;
  programs.fish.enable = true;
  environment.shells = [pkgs.bashInteractive pkgs.fish];

  # Enable CUPS to print documents.
  services.printing.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    # lowLatency = {
    #   # enable this module
    #   enable = true;
    #   # defaults (no need to be set unless modified)
    #   quantum = 64;
    #   rate = 48000;
    # };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cajun = {
    isNormalUser = true;
    description = "cajun";
    extraGroups = ["networkmanager" "wheel" "video" "xrdp"];
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmvR3ySxKdlez065jxyzz1eCK5BOuljTJaiAB7rVz9f windows desktop"
    ];
    packages = with pkgs; [
      firefox
      fish
      niv
      # nil
      nixd # A better nix language server
      slack
      obs-studio
      zoom-us

      # TODO: after switching to a flake, use `github:viperML/nh` instead
      nix-output-monitor
      busybox
      toybox

      units

      # vmware-workstation

      pwndbg

      steam-run

      minigalaxy
      lutris # GoG Games

      moar # better pager
      procs # better ps

      pavucontrol # Audio control (I hate linux)
      alsa-utils

      inetutils # Why isn't this installed by default??
      p7zip

      signal-desktop # Always out of date :3

      remmina # RDP

      # gnuradio
      arandr # you know why
      htop
      ncdu

      tailscale
      openvpn

      wgnord
    ];
  };

  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "xmonad";
    audio.enable = true;
  };

  # programs.openvpn3.enable = true;

  systemd.timers."wallpaper-tool" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-1 00:00:00";
      AccuracySec = "1h";
      Persistent = true;
      Unit = "wallpaper-tool.service";
    };
  };

  systemd.services."wallpaper-tool" = {
    script = ''
      set -eu
      ${inputs.cajun-wallpaper-tool}/bin/cajun-kriegs-wallpaper cajun
      ${pkgs.feh}/bin/feh --bg-scale ${config.users.users.cajun.home}/Pictures/wallpaper.jpg
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "cajun";
      Group = "cajun";
      ProtectHome = "off";
    };
  };

  # Dynamic loader assistance for pre-build binaries
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Without these it silently fails
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libSM
      xorg.libICE

      xorg.libXt
      xorg.libXmu
      xorg.libXft
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # extraCompatPackages = [
    #   # add the packages that you would like to have in Steam's extra compatibility packages list
    #   # pkgs.luxtorpeda
    #   # inputs.nix-gaming.packages.${pkgs.system}.proton-ge
    #   nix-gaming.packages.${pkgs.hostPlatform.system}.proton-ge
    #   # etc.
    # ];
  };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  # Allow broken packages
  # nixpkgs.config.allowBroken = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.sessionVariables = rec {
    NIXD_FLAGS = "--inlay-hints=true --semantic-tokens=true";
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    # system76-firmware
    # system76-keyboard-configurator
    dmenu
    # SOLUTION: write a function that just runs it normally, rather than making
    # a new default.nix and whatnot
    (callPackage ./rcu {
      #rcu-tar-path = config.age.secrets."rcu.tar.gz".path;
    })

    (callPackage ./binaryninja.nix {})

    # (callPackage ./binaryninja {
    #   #binary-ninja-path = config.age.secrets."binary-ninja.tar.gz".file;
    # })
    # (inputs.binary-ninja.packages.${pkgs.system}.binary-ninja-personal.overrideAttrs (old: {
    #   src = /nix/store/a0hgfba2ppclbvshv1rwgjraikspa17q-binary-linux-personal.zip;
    # }))
    #
    steam-run
    wireshark
    # shit that doesn't work on nixos? Probably need to sink a few hours here
    # cloudflare-warp
    #
    spice-gtk
    # server management
    terraform
    flyctl
    # linux manpages
    linux-manual
    man-pages
    man-pages-posix

    # jetbrains.idea-ultimate
    # jetbrains.jdk
    # graalvm11-ce
    # (jetbrains.rider.overrideAttrs (attrs: {
    #   nativeBuildInputs =
    #     jetbrains.rider.nativeBuildInputs
    #     ++ [
    #       icu
    #       pkgconf
    #     ];
    # }))
    icu # requirement for dotnet & rider
    # jdk11
    fontconfig
    # python3
    # nix-gaming.packages.${pkgs.hostPlatform.system}.proton-ge
    #haskell.packages.ghc92.ghc
  ];

  virtualisation.spiceUSBRedirection.enable = true;
  # virtualisation.vmware.host.enable = true;

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
    '';
  };
  # security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
  # TODO: move symlinks like graalvm to dedicated file
  # environment.etc."jdks/graalvm11-ce".source = "${pkgs.graalvm11-ce}";
  # services.cloudflared.tunnels.nuccdc.warp-routing.enabled = true;
  # services.cloudflared = {
  #   enable = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
