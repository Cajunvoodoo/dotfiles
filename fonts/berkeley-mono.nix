{
  lib,
  requireFile,
  stdenvNoCC,
  unzip,
  # , variant ? "ligatureson-0variant1-7variant0"
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "berkeley-mono";
  version = "1.009";

  src = requireFile rec {
    name = "TX-02.zip";
    sha256 = "0qp07fz3fzhdvngaizbgyyxf72ixrclpfs73zr6zg09hpg7ckbjf";
    message = ''
      This file needs to be manually downloaded from the Berkeley Graphics
      site (https://berkeleygraphics.com/accounts). An email will be sent to
      get a download link.

      Download the zip file, then run:

      mv \$PWD/TX-02.zip \$PWD/${name}
      nix-prefetch-url --type sha256 file://\$PWD/${name}
    '';
  };

  # outputs = ["out"]; # "web" "variable" "variableweb"];

  nativeBuildInputs = [
    unzip
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype *.ttf
    # install -D -m444 -t $out/share/fonts/opentype berkeley-mono/*.otf

    runHook postInstall
  '';
})
