# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ variables, config, pkgs, ... }:

let
  # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
  # nh = import (builtins.fetchTarball "https://github.com/viperML/nh/archive/master.tar.gz");
  # nixd = import (builtins.fetchTarball "https://github.com/nix-community/nixd/archive/refs/tags/2.0.2.tar.gz");
  xmonad-config = (import /home/cajun/Projects/Haskell/xmonad-flake).nixosModules;
in
{
  imports =
    [
      #include system configuration, which does not rely on home-manager
      ./system/system.nix
      <home-manager/nixos>
      # nix-gaming.nixosModules.pipewireLowLatency
      # (nh.nixosModules)

    ];

  nixpkgs.overlays = [
    (self: super: {
      cajun-xmonad = (builtins.getFlake "/home/cajun/Projects/Haskell/xmonad-flake").nixosModules.default;
    })
    # (newPkg: oldPkgs: {
    #   haskellPackages = oldPkgs.haskellPackages.override (old: {
    #     overrides = oldPkgs.lib.composeExtensions (old.overrides or (_: _: {  }))
    #       (self: super: {
    #         cajun-xmonad = self.callCabal2nix "cajun-xmonad" /home/cajun/Projects/Haskell/xmonad-flake {};
    #       });
    #   });
    # })
  ];

  # cajun.desktop.wm = {
  #   enable = true;
  # };


  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" "ca-derivations"];
      trusted-users = [ "@wheel" ];
    };
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      #FIXME: make this dependent on a variable instead of strictly cajun
      "nixos-config=/home/cajun/dotfiles/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  documentation.nixos.enable = true;
  documentation.man.generateCaches = false;

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
  environment.shells = [ pkgs.bashInteractive pkgs.fish ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.fish;
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

      pwndbg

      rmfakecloud

      nixfmt-rfc-style
      (callPackage ./rcu { })

      steam-run

      minigalaxy
    ];
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xmonad";
    openFirewall = true;
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

  systemd.services.rmfakecloud = {
    enable = false;
    description = "Fake cloud service for Remarkable devices";

    unitConfig = {
      Type = "simple";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    serviceConfig = {
      ExecStart = "${pkgs.rmfakecloud}/bin/rmfakecloud";
      EnvironmentFile = config.age.secrets.rmfakecloud-env.path;
    };

    wantedBy = [ "multi-user.target" ];
  };

  #configure home-manager for cajun
  home-manager.users.cajun = import ./home/home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Allow broken packages
  # nixpkgs.config.allowBroken = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
 #  wget
    system76-firmware
    system76-keyboard-configurator
    dmenu
    (callPackage ./binaryninja { })
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

    jetbrains.idea-ultimate
    jetbrains.jdk
    # graalvm11-ce
    # jdk11
    fontconfig
    # python3
    # nix-gaming.packages.${pkgs.hostPlatform.system}.proton-ge
    #haskell.packages.ghc92.ghc

  ];
  virtualisation.spiceUSBRedirection.enable = true;

  programs.ssh = {
    startAgent = true;
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
