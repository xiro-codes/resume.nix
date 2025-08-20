{
  description = "Latex based resume built with nix";
  inputs = {
      nixpkgs.url = github:nixos/nixpkgs;
      flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };
  outputs = { self, nixpkgs, flake-utils }:
  let
     system = "x86_64-linux";
     # Personal information and resume content imported from separate files
     personalInfo = import ./info/personal.nix;
     
     resumeContent = {
       summary = import ./info/summary.nix;
       skills = import ./info/skills.nix;
       education = import ./info/education.nix;
       experience = import ./info/experience.nix;
       organizations = import ./info/organizations.nix;
     };
  in flake-utils.lib.eachSystem [ system ] (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    
    # Generate M4 definitions from personal info
    generateSkillsM4 = skills: pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.imap0 (i: skill: 
        "define(*[SKILL${toString i}_CATEGORY]*, *[${skill.category}]*)\ndefine(*[SKILL${toString i}_SKILLS]*, *[${skill.skills}]*)"
      ) skills
    );
    
    generateEducationM4 = education: pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.imap0 (i: edu: 
        "define(*[EDU${toString i}_DEGREE]*, *[${edu.degree}]*)\ndefine(*[EDU${toString i}_INSTITUTION]*, *[${edu.institution}]*)\ndefine(*[EDU${toString i}_LOCATION]*, *[${edu.location}]*)\ndefine(*[EDU${toString i}_DATES]*, *[${edu.dates}]*)"
      ) education
    );
    
    generateExperienceM4 = experience: pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.imap0 (i: exp: 
        let
          itemsM4 = pkgs.lib.concatStringsSep "\n" (
            pkgs.lib.imap0 (j: item: 
              "define(*[EXP${toString i}_ITEM${toString j}]*, *[${item}]*)"
            ) exp.items
          );
        in
        "define(*[EXP${toString i}_TITLE]*, *[${exp.title}]*)\ndefine(*[EXP${toString i}_ORGANIZATION]*, *[${exp.organization}]*)\ndefine(*[EXP${toString i}_LOCATION]*, *[${exp.location}]*)\ndefine(*[EXP${toString i}_DATES]*, *[${exp.dates}]*)\n${itemsM4}"
      ) experience
    );
    
    generateOrganizationsM4 = organizations: pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.imap0 (i: org: 
        let
          itemsM4 = pkgs.lib.concatStringsSep "\n" (
            pkgs.lib.imap0 (j: item: 
              "define(*[ORG${toString i}_ITEM${toString j}]*, *[${item}]*)"
            ) org.items
          );
        in
        "define(*[ORG${toString i}_TITLE]*, *[${org.title}]*)\ndefine(*[ORG${toString i}_ORGANIZATION]*, *[${org.organization}]*)\ndefine(*[ORG${toString i}_LOCATION]*, *[${org.location}]*)\ndefine(*[ORG${toString i}_DATES]*, *[${org.dates}]*)\n${itemsM4}"
      ) organizations
    );
    
    generateM4Defs = info: content: pkgs.lib.concatStringsSep "\n" [
      "define(*[FIRSTNAME]*, *[${info.name.first}]*)"
      "define(*[LASTNAME]*, *[${info.name.last}]*)"  
      "define(*[POSITION]*, *[${info.position}]*)"
      "define(*[ADDRESS]*, *[${info.address}]*)"
      "define(*[EMAIL]*, *[${info.email}]*)"
      "define(*[MOBILE]*, *[${info.mobile}]*)"
      "define(*[GITHUB]*, *[${info.github}]*)"
      "define(*[QUOTE]*, *[${info.quote}]*)"
      "define(*[SUMMARY]*, *[${content.summary}]*)"
      (generateSkillsM4 content.skills)
      (generateEducationM4 content.education)
      (generateExperienceM4 content.experience)
      (generateOrganizationsM4 content.organizations)
    ];
    
    m4Definitions = generateM4Defs personalInfo resumeContent;
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
            
            # Write M4 definitions to a file
            cat > personal-info.m4 << 'EOF'
${m4Definitions}
define(*[fluff]*, *[1]*)
EOF

            ${m4}/bin/m4 personal-info.m4 resume.tex > $name.tex
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

          # Write M4 definitions to a file
          cat > personal-info.m4 << 'EOF'
${m4Definitions}
EOF

          ${m4}/bin/m4 personal-info.m4 resume.tex > $name.tex
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
