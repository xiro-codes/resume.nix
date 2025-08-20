# Example: Customizing Your Resume

This is an example of how easy it is to customize your resume by editing the Nix configuration.

## Step 1: Update Personal Information

Edit `flake.nix` and find the `personalInfo` section:

```nix
personalInfo = {
  name = {
    first = "John";        # <- Change to your first name
    last = "Doe";          # <- Change to your last name
  };
  position = "Software Engineer";  # <- Your job title
  address = "San Francisco, CA";   # <- Your location
  email = "john@example.com";      # <- Your email
  mobile = "(555) 123-4567";       # <- Your phone
  github = "johndoe";              # <- Your GitHub username
  quote = "Building the future, one line of code at a time.";  # <- Your quote
};
```

## Step 2: Update Resume Content

### Summary
```nix
summary = "Experienced software engineer with 5+ years developing web applications...";
```

### Add Your Skills
```nix
skills = [
  { category = "Languages"; skills = "Python, JavaScript, Go, Rust"; }
  { category = "Frameworks"; skills = "React, Django, FastAPI"; }
  { category = "Tools"; skills = "Docker, Kubernetes, AWS"; }
];
```

### Add Your Experience
```nix
experience = [
  {
    title = "Senior Software Engineer";
    organization = "Tech Corp";
    location = "San Francisco, CA";
    dates = "Jan. 2022 - Present";
    items = [
      "Led development of microservices architecture serving 1M+ users"
      "Reduced deployment time by 60% through CI/CD improvements"
      "Mentored 3 junior developers and conducted code reviews"
    ];
  }
  {
    title = "Software Engineer";
    organization = "Startup Inc";
    location = "Remote";
    dates = "Jun. 2020 - Dec. 2021";
    items = [
      "Built responsive web applications using React and Node.js"
      "Implemented automated testing reducing bugs by 40%"
      "Collaborated with design team on user experience improvements"
    ];
  }
];
```

### Add Your Education
```nix
education = [
  {
    degree = "M.S. Computer Science";
    institution = "Stanford University";
    location = "Stanford, CA";
    dates = "2018 - 2020";
  }
  {
    degree = "B.S. Computer Science";
    institution = "UC Berkeley";
    location = "Berkeley, CA";
    dates = "2014 - 2018";
  }
];
```

## Step 3: Build Your Resume

```bash
# Generate core resume
nix build

# Generate full resume with additional sections
nix build .#resume-with-fluff
```

## Step 4: Find Your PDF

Your generated resume will be in `result/share/compiled-document/`

## That's It!

No more editing LaTeX files or worrying about formatting. Just update your data in the Nix configuration and rebuild. The LaTeX templates handle all the formatting automatically!

## Adding New Sections

You can easily add new data to any section. For example, to add another job:

```nix
experience = [
  # ... existing jobs ...
  {
    title = "Junior Developer";
    organization = "First Company";
    location = "Austin, TX";
    dates = "May 2019 - May 2020";
    items = [
      "Developed RESTful APIs using Python and Flask"
      "Worked with PostgreSQL databases and complex queries"
    ];
  }
];
```

The M4 preprocessing will automatically handle the new entry and generate the appropriate placeholders.