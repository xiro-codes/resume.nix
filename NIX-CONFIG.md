# Nix-based Resume Configuration

This project now stores all personal information and resume content in Nix configuration files, using LaTeX purely for formatting.

## How it Works

The build system uses M4 preprocessing to substitute content from Nix configuration into LaTeX templates:

1. **Personal Info & Content**: Organized in separate files in the `info/` directory
2. **Import System**: Main `flake.nix` imports all data files
3. **M4 Generation**: Nix functions convert data into M4 definitions  
4. **LaTeX Templates**: Use M4 placeholders instead of hardcoded values
5. **Build Process**: M4 preprocessor substitutes placeholders with actual data

## Configuration Structure

All resume data is organized in the `info/` directory:

- `info/personal.nix` - Personal contact information and basic details
- `info/summary.nix` - Professional summary text
- `info/skills.nix` - Technical skills organized by category
- `info/education.nix` - Educational background and certifications
- `info/experience.nix` - Work experience with detailed descriptions
- `info/organizations.nix` - Volunteer work and organizational involvement

### Personal Information (`info/personal.nix`)

```nix
{
  name = { first = "First"; last = "Last"; };
  position = "Job Title";
  address = "City, State";
  email = "email@example.com";
  mobile = "(555) 123-4567";
  github = "github-username";
  quote = "Your personal quote";
}
```

### Resume Content

#### Summary (`info/summary.nix`)
```nix
"Your professional summary text..."
```

#### Skills (`info/skills.nix`)
```nix
[
  { category = "Category Name"; skills = "Skill1, Skill2, Skill3"; }
  # ... more skill categories
]
```

#### Education (`info/education.nix`)
```nix
[
  {
    degree = "Degree Name";
    institution = "School Name";
    location = "City, State";
    dates = "Start - End";
  }
  # ... more education entries
]
```

#### Experience (`info/experience.nix`)
```nix
[
  {
    title = "Job Title";
    organization = "Company Name";
    location = "City, State";
    dates = "Start - End";
    items = [
      "First accomplishment or responsibility"
      "Second accomplishment or responsibility"
      # ... more bullet points
    ];
  }
  # ... more experience entries
]
```

#### Organizations/Open Source (`info/organizations.nix`)
```nix
[
  {
    title = "Role/Position";
    organization = "Organization Name";
    location = "Location or URL";
    dates = "Start - End";
    items = [
      "First contribution or accomplishment"
      "Second contribution or accomplishment"
    ];
  }
  # ... more organization entries
]
```

## LaTeX Templates

LaTeX files now use M4 placeholders:

- `FIRSTNAME`, `LASTNAME` - Personal name
- `EMAIL`, `MOBILE`, `ADDRESS` - Contact info
- `SUMMARY` - Professional summary
- `SKILL0_CATEGORY`, `SKILL0_SKILLS` - Skills (indexed)
- `EDU0_DEGREE`, `EDU0_INSTITUTION` - Education (indexed)
- `EXP0_TITLE`, `EXP0_ITEM0` - Experience (indexed)
- `ORG0_TITLE`, `ORG0_ITEM0` - Organizations (indexed)

## Building

- `nix build` - Core resume (no "fluff" sections)
- `nix build .#resume-with-fluff` - Full resume with organizations/projects

## Benefits

✅ **Single Source of Truth**: All data in Nix configuration  
✅ **Type Safety**: Nix provides structure validation  
✅ **Version Control**: Easy to track content changes  
✅ **Modularity**: Separate data from presentation  
✅ **Automation**: Can generate different resume versions  

## Customizing

1. Edit personal information in `flake.nix` 
2. Add/modify resume content sections
3. LaTeX files handle only formatting and layout
4. Build system automatically generates PDF with your data