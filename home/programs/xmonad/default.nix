{
  pkgs,
  config,
  inputs,
  ...
}: let
  extra = ''
    set +x
    ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.autorandr}/bin/autorandr --change
  '';
  polybarOpts = ''
    ${pkgs.feh}/bin/feh --bg-scale ${config.xdg.userDirs.pictures}/wallpaper.jpg &
    ${pkgs.blueman}/bin/blueman-applet &
    ${pkgs.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator &
  '';
  #TODO: add xcape to the above
in {
  home.packages = with pkgs; [
    dialog # Dialog boxes on the terminal (to show key bindings)
    networkmanager_dmenu # networkmanager on dmenu
    xcape # keymaps modifier
    xorg.xkbcomp # keymaps modifier
    xorg.xmodmap # keymaps modifier
    xorg.xrandr # display manager (X Resize and Rotate protocol)
    trayer
    xmobar
    kitty
    dmenu
    playerctl
    inputs.xmobar-cajun.packages.${pkgs.system}.default
    hack-font
    hackgen-nf-font
    hackgen-font
  ];

  xresources.properties = {
    #"Xft.dpi" = 180;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    #"Xft.rgba" = "rgb";
    "Xcursor*theme" = "Vanilla-DMZ-AA";
    #"Xcursor*size" = 24;
  };

  xsession = {
    enable = true;

    initExtra = extra + polybarOpts;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp:
        with hp; [
          aeson
          async
          bytestring
          dbus
          hinotify
          http-conduit
          monad-logger
          stm
          text
          xmobar
        ];
      libFiles = {
        # "Monitors.hs" = ./Monitors.hs;
        # "Single.hs" = ./Single.hs;
        # "Config.hs" = ./Config.hs;
        "xmobars.sh" = ./xmobars.sh;
      };
      config = ./xmonad.hs;
    };
  };
  # home.file = {
  #   ".config/xmobar/xmobar.hs".source = ./Single.hs;
  #   ".config/xmobar/Config.hs".source = ./Config.hs;
  #   ".config/xmobar/Monitors.hs".source = ./Monitors.hs;
  # };
}
