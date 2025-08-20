{
  description = "Latex based resume built with nix";
  inputs = {
      nixpkgs.url = github:nixos/nixpkgs;
      flake-utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };
  outputs = { self, nixpkgs, flake-utils }:
  let
     system = "x86_64-linux";
     # Personal information and resume content
     personalInfo = {
       name = {
         first = "Travis O.";
         last = "Davis";
       };
       position = "Web {\\enskip\\cdotp\\enskip} Developer";
       address = "Cordova, Tennessee";
       email = "me@tdavis.dev";
       mobile = "(901)-505-9122";
       github = "travisdavis-ops";
       quote = "``Study hard what interests you the most in the most undisciplined, irreverent and original manner possible.\"~~~·~~~Richard Feynmann ";
     };

     resumeContent = {
       summary = "As an aspiring entry-level programmer and avid enthusiast of Linux and Open Source Software, I thrive on customizing every aspect of my development environment. Passionate about devising innovative problem-solving methods for challenging tasks, I am eager to learn new technologies and tools as needed. With a strong work ethic and a dedication to efficiency, I am poised to leverage my existing skills and abilities in pursuit of professional growth.";
       
       skills = [
         { category = "DevOps"; skills = "AWS, Docker, Nix, Ansible"; }
         { category = "Back-end"; skills = "Express, Django, Codignter "; }
         { category = "Front-end"; skills = "React, Redux, Jquery, Bootstrap"; }
         { category = "Programming"; skills = "Javascript, Python, Rust, Php, Nix, Java "; }
         { category = "Databases"; skills = "PostgreSQL, MySQL, MongoDB, SQLite"; }
       ];
       
       education = [
         {
           degree = "Fullstack Development Training";
           institution = "York Solutions(Barriers to Entry)";
           location = "(Remote) Westchester, IL";
           dates = "Apr. 2022 - Jul. 2022";
         }
         {
           degree = "Certificate in Web Development";
           institution = "Tech 901";
           location = "Memphis, Tn.";
           dates = "Aug. 2019 - Dec. 2019";
         }
         {
           degree = " High School Diploma ";
           institution = "Cordova High School";
           location = "Cordova, Tn.";
           dates = "Sep. 2010 - Mar. 2014";
         }
       ];
       
       experience = [
         {
           title = "Instructor/Software Developer";
           organization = "York Solutions";
           location = "Westchester, Il.";
           dates = "Apr. 2022 - Apr. 2023";
           items = [
             "Conducted comprehensive training sessions for groups of up to 20 individuals, focusing on the core principles of Full Stack Web Development. Adapted curriculum to suit clients' specific requirements, utilizing a diverse range of frameworks."
             "Collaborated in the development of internal tools to streamline testing procedures and evaluate project progress, contributing to enhanced efficiency and accuracy within the team."
             "Offered continuous support and supplementary training to contracted developers, specializing in the utilization of advanced tools to optimize workflow and project outcomes."
           ];
         }
         {
           title = "Teachers's Assistant";
           organization = "Tech 901";
           location = "Memphis, Tn.";
           dates = "Mar. 2022 - Jul. 2022";
           items = [
             "Collaborated with teachers in planning and preparing lessons, resulting in increased student engagement and comprehension."
             "Conducted regular assessments to tailor instruction, leading to improved academic performance."
             "Provided technical support to students and staff, enhancing productivity by resolving hardware and software issues."
           ];
         }
         {
           title = "Assistant Programmer";
           organization = "Upper Edge Technologies ";
           location = "West Memphis, Ar.";
           dates = "Dec. 2019 - Jan. 2022";
           items = [
             "Developed a Customer Quoting tool, integrating catalog browsing and automating manual bookkeeping for sales representatives."
             "Engineered a digital RMA process using third-party APIs (QuickBooks, BigCommerce, \\& Jira), improving efficiency in returns management."
             "Created REST APIs for receiving parts\\/laptop specifications alongside inventory numbers, enhancing data transfer and inventory tracking capabilities."
           ];
         }
       ];
       
       organizations = [
         {
           title = "Package Mantainer";
           organization = "Nix/Nixos/Nixpkgs";
           location = "https://nixos.org";
           dates = "Aug. 2021 - PRESENT";
           items = [
             "Experienced the in and outs of getting a variety Linux application working in non standard environments."
             "Learning about working with git \\& GitHub on a larger scale. "
           ];
         }
       ];
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
