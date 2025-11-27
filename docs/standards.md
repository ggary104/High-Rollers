# CSCI 265 Team Standards and Processes (Phase 2)

## Team name: The High Rollers

## Project/product name: High Rollers

## Key contact person and email

 - Seth, seth.william.doyle@gmail.com *main contact*

## Document structure

In this document we will be addressing three core areas of standards and processes:
 - Documentation standards and processes
 - Coding standards and processes
 - Version control standards and processes
   
Each section includes a discussion of how those standards and processes will be enforced, and how they will be reviewed for potential updates as the project progresses.

## Documentation standards and processes

A Documentation directory will be maintained in the top level of our team project repository. Within that directory, we will maintain all project-related documents. This list will be updated as the project evolves. Each document will have a primary author (usually the lead for that area) and a secondary author (the understudy), both responsible for maintaining accuracy and consistency.
The current documentation structure includes:
 - proposal.md (Harman): Project proposal deliverable (Phase 1)
 - charter.md (Harman): Team charter deliverable (Phase 1)
 - standards.md (Harman): Standards and processes deliverable (Phase 2)
 - requirements.md (Abhi and Harman): Product requirements deliverable (Phase 2–3)
 - design.md (Joseph and Harman): Game design deliverable (Phase 3)
 - testplan.md (Harman and Seth): Test plan deliverable (Phase 4)
 - updates.md (Harman and Gary): Progress updates maintained throughout all phases

An Images subdirectory will be included inside the documentation directory, containing all images referenced in the .md files. File names for images must begin with the name of the related document, followed by an underscore and a short descriptor (e.g., design_wireframe.png).

All documentation will use a consistent layout and heading style following the structure of the course-provided templates. Each team member will be responsible for checking spelling (Canadian English), grammar, and formatting for their contributions. The primary author for each document will conduct a final review before submission, and the secondary author will double-check sections written by the primary author.

Document submissions and revisions will be done through pull requests (PRs) to ensure all changes are reviewed before merging into the main branch.

Following the completion of Phase 2, the team will evaluate how effectively the documentation standards and processes worked and make updates as needed. Similar review discussions will occur at the end of later phases if required.

## Coding standards and processes

Our project will primarily be developed using Godot Engine and GDScript, which follows Python-like syntax. For consistency and readability, we will adopt the official Godot GDScript style guide as our primary coding standard. This includes naming conventions, indentation, comment formatting, and file structure. For any future use of C++ or external libraries, we will follow the Google C++ Style Guide.

All code produced by team members will be reviewed by the Technical Implementation Lead or Development Lead before it is merged into the main development branch. Code written by a lead must be reviewed by their understudy. Review turnaround time may take up to 48–72 hours, so contributors must plan submissions accordingly.
All code changes and additions must be submitted via pull requests. Each PR should include:
 - A clear and specific title summarizing the change.
 - A short description in the PR body explaining the purpose of the change and its effect on gameplay or behavior.
 - References to related issues, bugs, or tasks (if applicable).

No single commit should alter more than 200 lines of code. Separate commits must be used to address distinct issues or features.

As the project evolves and our familiarity with Godot deepens, we will review and refine these coding standards during Phase 3 to account for any new requirements, libraries, or coding challenges.

## Version control standards and processes

The team’s GitHub repository has been set up and is maintained by the Version Control Lead, who has administrative privileges. The instructor has been invited to the repository.
The repository will include three primary branches:
 - main — the stable, tested version submitted for marking
 - testing — the pre-production branch used for final testing and review
 - dev — the active development branch where new features and changes are merged once approved

Each team member will maintain their own local clone of the dev branch. Members must pull regularly from the team dev branch to stay updated with approved changes.
When a team member’s local work is ready to be integrated, they must:
 1. Pull from the latest version of the team dev branch.
 2. Resolve any conflicts and test their work locally.
 3. Ensure their code follows the team’s coding standards.
 4. Submit a pull request and post in the team’s communication channel for review.

The Version Control Lead (or understudy) will handle merges into the dev branch after reviewing the pull request with the Technical Implementation Lead or Development Lead.

**Team members must never directly edit content in the testing or production branches.**

Commit guidelines:
 - Commit messages must clearly describe what was changed.
 - Each commit should focus on one purpose (e.g., bug fix, feature addition, refactor).
 - The body of the commit should describe how the change affects gameplay or functionality.
 - No single commit should exceed 200 lines of change.

The team will review and refine these version control processes after Phase 2 once we have tested them through our documentation and prototype updates. Any issues or inefficiencies discovered will be addressed to improve workflow consistency and reliability.
These standards and processes aim to ensure clear communication, code quality, and consistent collaboration across all project phases. The team will review each area regularly and update this document as the project evolves to maintain best practices and ensure the success of High Rollers.




# CSCI 265 Team Standards and Processes (Final Version – Phase 4)

## Team Name: The High Rollers
## Project/Product Name: High Rollers

## Key Contact Person and Email
- Seth — seth.william.doyle@gmail.com (main contact)

# Document Structure
This document outlines the final set of standards and processes followed by The High Rollers team during the full development of the project. These standards were refined throughout Phases 1–4 and represent the mature workflow used for all final deliverables, coding, collaboration, and repository management.

This document covers:
- Documentation standards and processes  
- Coding standards and processes  
- Version control standards and processes  

Each section includes detailed procedures, enforcement methods, and review practices that have been consistently applied across the project.

# Documentation Standards and Processes
A docs/ directory is maintained at the top level of the repository, containing all project documentation. During Phases 3 and 4, this structure stabilized and remained consistent to ensure clarity and reproducibility.

### Documentation Files and Maintainers
- proposal.md — Phase 1 proposal (Primary: Harman; Secondary: Seth)  
- charter.md` — Team charter (Primary: Harman; Secondary: Seth)  
- requirements.md` — Updated through Phase 3 (Primary: Abhi; Secondary: Harman)  
- standards.md` — Standards and processes (Primary: Harman; Secondary: Gary)  
- design.md` — Logical and technical design (Primary: Joseph; Secondary: Harman)  
- testplan.md` — Phase 4 test plan (Primary: Harman; Secondary: Seth)  
- updates.md` — Ongoing progress log across all phases (Primary: Harman; Secondary: Gary)  
- closeout.md` — Phase 6 closeout document (Primary: Harman; Secondary: Seth)

All images used in documentation are stored in docs/Images/ and must follow the naming pattern:
<descriptor>.<filetype>
**example** 
design_wireframes.png


### Formatting Requirements
All project documents must:
- Use Markdown formatting  
- Follow the structure of the provided course templates  
- Maintain consistent heading levels and spacing  
- Use Canadian English  
- Remain clear, technical, and professional in tone  
- Include diagrams or figures when helpful  

### Writing Quality & Review Process
As the project approached final stages, strict review standards were enforced:

1. **Every contributor** must spell-check and grammar-check their writing (Google Docs, Grammarly Free).  
2. Every update must be submitted through a **pull request**.  
3. **Primary author** reviews all contributions for clarity, style, and correctness.  
4. **Secondary author** verifies the final document for organization and consistency.  
5. Documents for final submission must be complete **48 hours before the deadline**, allowing time for team-wide review.  

### Multi-Author Coordination for Final Documents
For late-phase deliverables (design, test plan, final writeups):

1. Parts were divided among specific authors.  
2. Each part was submitted as an individual PR.  
3. The primary author merged them into the final document.  
4. The full team reviewed the compiled document in the final 24-hour window.  

### Final Review of Documentation Standards
By Phase 4, the team confirmed that:
- The documentation workflow was efficient  
- The PR system ensured accountability and avoided overwriting  
- The process supported consistent, high-quality deliverables  

No changes were required for the final phase.

# Coding Standards and Processes
All development for High Rollers uses **Godot 4.x** and **GDScript**. The team adopted and consistently followed the official GDScript Style Guide:

https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

### Coding Style Requirements
- 4-space indentation  
- snake_case for variables, functions, signals  
- PascalCase for classes  
- Maximum clarity in naming  
- One scene per functional game component  
- Scripts kept modular and single-responsibility  
- Comments required for:  
  - Any non-obvious calculation  
  - Game mechanics rules  
  - UI behaviour logic  
  - Multiplayer or networking logic

### Code Review Process (Final Phase)
The review process became stricter in Phase 4, ensuring stable release-quality code:

1. All code changes were submitted through **pull requests**.  
2. The Technical Implementation Lead or Development Lead reviewed each PR.  
3. Code from leads was reviewed by understudies.  
4. Review turnaround was **24–48 hours** during final development.  
5. All logic affecting gameplay (scoring, dice behaviour, turn flow) required detailed commit messages.  

### Pull Request Requirements
A valid PR must include:
- A descriptive title  
- Summary of what was added/changed  
- Explanation of gameplay or system impact  
- Screenshots or short video if UI elements changed  
- Reference to task list (if applicable)  

### Commit Requirements
- Max **200 lines** per commit  
- One feature or fix per commit  
- Clear and specific commit messages  
- Commit body explains gameplay impact  

**Example:**
Implement Hot Dice mode scoring multipliers:
- Adds triple-dice multiplier rule
- Integrates into existing score calculator
- Updates UI to reflect new scoring logic


### Final Coding Standards Review
By Phase 4, the coding workflow was stable. The team agreed the use of PRs, reviews, and style guide adherence ensured consistency and prevented regressions.

No further changes were needed for the final submission phase.

# Version Control Standards and Processes

### Repository Structure
The final repository follows this structure:
High-Rollers/
├── docs/
├── game/ # Godot project
├── prototype/ # C++ prototype
├── presentations/
└── README.md

### Branching Model
The team used a reliable three-branch model:

- **main** — stable version submitted for marking  
- **testing** — release candidates for QA and bug fixing  
- **dev** — active development branch  

### Branch Rules
- No direct edits to main or testing.  
- All work must originate from personal clones of dev.  
- Members must pull from dev before starting new work and before creating PRs.  

### Final PR Workflow
Before submitting a PR:

1. Pull latest dev  
2. Fix conflicts  
3. Test fully in Godot  
4. Confirm adherence to coding standards  
5. Submit PR and notify the team via Discord  

The Version Control Lead merges PRs only after approval by:
- Version Control Lead or understudy  
- Technical Implementation Lead (for logic changes)  

### Commit and PR Enforcement (Phase 4)
- Commits are isolated, clear, and limited in size  
- PRs must pass code review and gameplay testing  
- Bug fixes must document how to reproduce and verify the fix  

### Final Review of Version Control Process
By Phase 4, the workflow was efficient and stable. No major revisions were needed except for stricter PR timing to accommodate final deadlines.


These final standards reflect the completed and polished workflow used during Phase 4 and final submission of the High Rollers project. The team consistently applied these standards to ensure high-quality documentation, clean and maintainable code, and reliable version control practices suitable for a professional collaborative project.

