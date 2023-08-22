{ config, pkgs, ...}:

let
  openCalendar = "${pkgs.xfce.orage}/bin/orage"
 
  hdmiBar = pkgs.callPackage ./bar.nix { };

  laptopBar = pkgs.callPackage ./bar.nix {
    font0 = 10;
    font1 = 12;
    font2 = 24;
    font3 = 18;
    font4 = 5;
    font5 = 10;
  };

  mainBar = if specialArgs.hidpi then hdmiBar else laptopBar;

  mypolybar = pkgs.polybar.override {
    alsoSupport   = true;
    githubSupport = true;
    mpdSupport    = true;
    pulseSupport  = true;
  };
  
  # theme adapted from: https://github.com/adi1090x/polybar-themes#-polybar-5
  bars = builtins.readFile ./bars.ini;
  colors = builtins.readFile ./colors.ini;
  mods1 = builtins.readFile ./modules.ini;
  mods2 = builtins.readFile ./user_modules.ini;

  mprisScript = pkgs.callPackage ./scripts/mpris.nix {};

  mpris = ''
    [module/mpris]
    type = custom/script

    exec = ${mprisScript}/bin/mpris
    tail = true

    label-maxlen = 60

    interval = 2
    format =  <label>
    format-padding = 2
  '';

  xmonad = ''
    [module/xmonad]
    type = custom/script
    exec = ${pkgs.xmonad-log}/bin/xmonad-log
    
    tail = true
  '';
in
{
  services.polybar = {
    enable = true;
    package = mypolybar;
    config = ./config.ini;
    extraConfig = bars + colors + mods1 + mods2 + mpris + xmonad;
    script = ''
      polybar top &
      polybar bottom &
    '';
  };
}
