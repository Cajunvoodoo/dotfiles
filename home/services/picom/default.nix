{
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.92;
    # backend = "xrender";
    backend = "glx";
    fade = true;
    fadeDelta = 1;
    opacityRules = ["100:name *= 'i3lock'"];
    shadow = true;
    shadowOpacity = 0.75;
  };
}
