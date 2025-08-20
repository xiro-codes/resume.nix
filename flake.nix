{
  description = "Latex based resume built with nix";
  inputs = {
      nixpkgs.url = github:nixos/nixpkgs;
      flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };
  outputs = { self, nixpkgs, flake-utils }:
  let
     system = "x86_64-linux";
  in flake-utils.lib.eachSystem [ system ] (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    env = pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic latexmk latex-bin luatexbase;
      inherit (pkgs.texlive) enumitem tcolorbox parskip hyperref geometry;
      inherit (pkgs.texlive) ragged2e everysel lualatex-math unicode-math;
      inherit (pkgs.texlive) iftex xifthen xcolor ifmtarg setspace etoolbox;
      inherit (pkgs.texlive) xkeyval fontspec environ pgf sourcesanspro fontawesome5;
      inherit (pkgs.texlive) emoji;
    };
    fonts = pkgs.stdenvNoCC.mkDerivation {
        pname = "fonts";
        version = "1.0.0";
        src = ./src/fonts;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp -r *.ttf $out/share/fonts/truetype
        '';
      };
  in with pkgs; rec {
    packages = {
      inherit fonts;

      cover = stdenvNoCC.mkDerivation rec {
        name = "cover";
        src = ./src;
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];
        buildInputs = [ makeWrapper coreutils env fonts ];
        buildPhase = ''
          mkdir -p build
          mkdir -p .cache/texmf-var
          env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              OSFONTDIR=${fonts}/share/fonts \
              latexmk -interaction=nonstopmode -output-directory=build -pdf -lualatex $name.tex
        '';
        installPhase = ''
          mkdir -p $out/share/compiled-document
          cp -r build/* $out/share/compiled-document/
          makeWrapper ${mupdf}/bin/mupdf $out/bin/$name --add-flags $out/share/compiled-document/$name.pdf
        '';
      };

      resume-with-fluff = stdenvNoCC.mkDerivation rec {
          name = "resume-with-fluff";
          src = ./src;
          buildInputs = [ makeWrapper coreutils env fonts m4];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];

          buildPhase = ''
            mkdir -p build
            mkdir -p .cache/texmf-var
            ${m4}/bin/m4 --define fluff resume.tex > $name.tex
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                SOURCE_DATE_EPOCH=${toString self.lastModified} \
                OSFONTDIR=${fonts}/share/fonts \
                latexmk -interaction=nonstopmode -output-directory=build -pdf -lualatex $name.tex
          '';
          installPhase = ''
            mkdir -p $out/share/compiled-document
            cp -r build/*.pdf $out/share/compiled-document/
            makeWrapper ${mupdf}/bin/mupdf $out/bin/$name --add-flags $out/share/compiled-document/$name.pdf
          '';
      };
      resume = defaultPackage;
    };

    defaultPackage = stdenvNoCC.mkDerivation rec {
        name = "core-resume";
        src = ./src;
        buildInputs = [ makeWrapper coreutils env fonts m4];
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];

        buildPhase = ''
          mkdir -p build
          mkdir -p .cache/texmf-var

          ${m4}/bin/m4 resume.tex > $name.tex
          env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              SOURCE_DATE_EPOCH=${toString self.lastModified} \
              OSFONTDIR=${fonts}/share/fonts \
              latexmk -interaction=nonstopmode -output-directory=build -pdf -lualatex $name.tex
        '';
        installPhase = ''
          mkdir -p $out/share/compiled-document
          cp -r build/*.pdf $out/share/compiled-document/
          makeWrapper ${mupdf}/bin/mupdf $out/bin/$name --add-flags $out/share/compiled-document/$name.pdf
        '';
    };

    devShell = mkShell {
      name="latex-env";
      buildInputs = [ coreutils env fonts ];
      packages = [ m4 ];
    };
  });
}
