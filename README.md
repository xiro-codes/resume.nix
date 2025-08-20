**Resume.nix**
================

A lightweight, customizable, and automated resume builder using Nix and LaTeX.

**Overview**

Resume.nix is a simple, yet powerful tool to create a professional-looking resume with minimal effort. 
Using Nix as the build system and LaTeX as the typesetting engine, this project automates the process of 
creating a resume, allowing you to focus on writing your skills, experience, and education rather than 
worrying about formatting.

**Features**

* **Customizable**: Easily modify the order of sections in your resume by editing the files located in 
`src/sections`.
* **Automated building**: No more manual typing or formatting errors. Let Nix and LaTeX do the heavy 
lifting for you!
* **Flake-based configuration**: Use Flakes to define and manage your resume's dependencies, making it 
easy to update your build tools and plugins.

**Getting Started**

1. Clone this repository: `git clone https://github.com/your-username/resume.nix.git`
2. Install Nix and Flakes: Follow the installation instructions for [Nix](https://nixos.org/nix/) and 
[Flakes](https://nixos.org/manual/nix/stable/flakes.html).
3. Edit the files in `src/sections` to customize the order of your resume's sections.
4. To modify the layout, design, or content of your resume, edit `src/resume.tex`.
5. Run `nix build` to generate a PDF file of your resume.

**GitHub Actions**

This project uses GitHub Actions to automate the building process. You can trigger a build by pushing 
changes to this repository or using the built-in CI/CD features in GitHub. The workflow will 
automatically create a PDF file and store it as an artifact, which you can then download and use as your 
resume.

**Tips and Tricks**

* To customize the order of sections in your resume, simply modify the files in `src/sections`.
* Use Nix's `flake.lock` file to manage dependencies and keep your build process up-to-date.
* To update the LaTeX template, edit `src/resume.tex`.

**License**

Resume.nix is released under the MIT License. See `LICENSE` for details.

**Contributing**

If you'd like to contribute to this project or suggest new features, please open an issue or submit a 
pull request. I welcome any feedback and suggestions that can help improve this tool!

Happy building!
