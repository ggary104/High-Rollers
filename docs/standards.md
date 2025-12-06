# CSCI 265 Team Standards and Processes (Phase 4)
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
- **conflict_fix** — release candidates for QA and bug fixing  
- **dev** — active development branch  

### Branch Rules
- No direct edits to main or conflict_fix.  
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

