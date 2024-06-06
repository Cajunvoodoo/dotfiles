{
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.8;
    backend = "xrender";
    fade = true;
    fadeDelta = 1;
    opacityRules = ["100:name *= 'i3lock'"];
    shadow = true;
    shadowOpacity = 0.75;
  };
}
