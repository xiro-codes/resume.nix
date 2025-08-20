# Resume Information Directory

This directory contains all personal information and resume content organized into separate Nix files for easy maintenance and customization.

## File Structure

- `personal.nix` - Personal contact information and basic details
- `summary.nix` - Professional summary text
- `skills.nix` - Technical skills organized by category
- `education.nix` - Educational background and certifications
- `experience.nix` - Work experience with detailed descriptions
- `organizations.nix` - Volunteer work and organizational involvement

## Usage

Each file exports a Nix expression that is imported by the main `flake.nix`. To update your resume:

1. Edit the relevant file(s) in this directory
2. Rebuild the resume with `nix build`

## Data Format

### Personal Information (`personal.nix`)
```nix
{
  name = { first = "First"; last = "Last"; };
  position = "Job Title";
  address = "City, State";
  email = "email@example.com";
  mobile = "Phone Number";
  github = "github-username";
  quote = "Professional quote";
}
```

### Skills (`skills.nix`)
```nix
[
  { category = "Category Name"; skills = "Skill1, Skill2, Skill3"; }
  # ... more categories
]
```

### Experience (`experience.nix`)
```nix
[
  {
    title = "Job Title";
    organization = "Company Name";
    location = "City, State";
    dates = "Start - End";
    items = [
      "Achievement or responsibility 1"
      "Achievement or responsibility 2"
    ];
  }
  # ... more positions
]
```

### Education (`education.nix`)
```nix
[
  {
    degree = "Degree Name";
    institution = "Institution Name";
    location = "City, State";
    dates = "Start - End";
  }
  # ... more education entries
]
```

### Organizations (`organizations.nix`)
Similar structure to experience, for volunteer work and organizational involvement.

### Summary (`summary.nix`)
A simple string containing your professional summary.