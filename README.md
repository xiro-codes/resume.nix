**Resume.nix**
================

A lightweight, customizable, and automated resume builder using Nix and LaTeX.

**Overview**

Resume.nix is a simple, yet powerful tool to create a professional-looking resume with minimal effort. 
Using Nix as the build system and LaTeX as the typesetting engine, this project automates the process of 
creating a resume, allowing you to focus on writing your skills, experience, and education rather than 
worrying about formatting.

**Key Features**

* **Nix Configuration**: All personal information and resume content is stored in Nix configuration files
* **Pure LaTeX Formatting**: LaTeX files handle only presentation and formatting - no hardcoded content
* **M4 Preprocessing**: Dynamic content substitution from Nix data into LaTeX templates
* **Type Safety**: Nix provides structure validation for your resume data
* **Version Control Friendly**: Easy to track content changes separate from formatting changes
* **Multiple Variants**: Generate different resume versions (core vs. full with additional sections)

**Getting Started**

1. Clone this repository: `git clone https://github.com/your-username/resume.nix.git`
2. Install Nix and Flakes: Follow the installation instructions for [Nix](https://nixos.org/nix/) and 
[Flakes](https://nixos.org/manual/nix/stable/flakes.html).
3. **Edit your personal information in `flake.nix`** - Update the `personalInfo` and `resumeContent` sections
4. Run `nix build` to generate a PDF file of your core resume
5. Run `nix build .#resume-with-fluff` to generate a full resume with additional sections

**Configuration**

All resume content is now configured in `flake.nix`:

- **Personal Info**: Name, contact details, position, quote
- **Summary**: Professional summary text  
- **Skills**: Categorized skill lists
- **Experience**: Job history with bullet points
- **Education**: Degrees and certifications
- **Organizations**: Open source contributions, etc.

See `NIX-CONFIG.md` for detailed configuration documentation.

**Building Variants**

* `nix build` - Core resume (summary, experience, skills, education)
* `nix build .#resume-with-fluff` - Full resume (includes organizations, projects)
* `nix build .#cover` - Cover letter

**GitHub Actions**

This project uses GitHub Actions to automate the building process. You can trigger a build by pushing 
changes to this repository or using the built-in CI/CD features in GitHub. The workflow will 
automatically create a PDF file and store it as an artifact, which you can then download and use as your 
resume.

**Migration to Nix Configuration**

This project has been updated to store all personal information and content in Nix configuration files rather than hardcoded in LaTeX. This provides:

- ✅ Single source of truth for all resume data
- ✅ Type safety and structure validation  
- ✅ Easy version control of content changes
- ✅ Separation of data from presentation
- ✅ Ability to generate multiple resume variants

**License**

Resume.nix is released under the MIT License. See `LICENSE` for details.

**Contributing**

If you'd like to contribute to this project or suggest new features, please open an issue or submit a 
pull request. I welcome any feedback and suggestions that can help improve this tool!

Happy building!
