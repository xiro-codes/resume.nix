**Resume Builder**
=====================

Build your resume using Nix and LaTeX, with automation by GitHub Actions.

**About this project**
-------------------------

The `resume.nix` project is an experimental tool for building and managing your resume. It combines the 
power of Nix (a package manager) and LaTeX (a typesetting system) to create a customizable, 
professional-looking resume that can be easily updated and maintained.

**Features**

* Automatic generation of PDF files from LaTeX source code
* Customizable template using LaTeX syntax
* Easy updating of information through YAML configuration file
* Automated building and deployment using GitHub Actions

**How it works**
-------------------

1. Clone this repository and create a new file `resume.yaml` in the root directory with your resume 
information (name, contact info, work experience, education, etc.)
2. Update the `resume.tex` file to customize the template as needed
3. Run `nix-build` to generate the PDF file from the LaTeX source code
4. Push changes to GitHub and let the automated workflow do the rest!

**GitHub Actions workflow**
-----------------------------

This project uses GitHub Actions to automate the building and deployment process. Here's a breakdown of 
what happens:

1. On push or pull request, the workflow is triggered
2. The `nix-build` command generates the PDF file from the LaTeX source code
3. The generated PDF file is uploaded as an artifact to GitHub
4. The workflow sends a notification to your email address with a link to the generated PDF

**Prerequisites**
-------------------

* Nix (version 2.7 or later)
* LaTeX (version 2020 or later)
* GitHub account and repository
* Familiarity with YAML and LaTeX syntax

**License**
----------

This project is licensed under the MIT License.

**Acknowledgments**
-------------------

This project was inspired by the work of others in the Nix community, particularly the 
[nix-literate](https://github.com/nix-literate) project. Special thanks to 
[LaTeX](http://latex-project.org/) for making typesetting so much fun!

I hope this helps! Let me know if you have any questions or need further clarification on how the project
works.

