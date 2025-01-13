{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts
      fira-code
      fira-code-symbols
      font-awesome_4
      font-awesome_5
      inconsolata
      ipaexfont
      jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      siji
      ubuntu_font_family
      julia-mono
      (callPackage ../../fonts/berkeley-mono.nix {})
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["TX-02" "JuliaMono" "Fira Code"];
      };
      # localConf =
      #   builtins.writeFile "fonts.xml"
      #   /*
      #   xml
      #   */
      #   ''
      #     <?xml version="1.0"?>
      #     <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      #     <fontconfig>
      #        <match target="pattern">
      #           <test qual="any" name="family" compare="eq"><string>Berkeley Mono</string></test>
      #           <edit name="family" mode="assign" binding="same"><string>JuliaMono</string></edit>
      #        </match>
      #     </fontconfig>
      #   '';
    };
  };
}
