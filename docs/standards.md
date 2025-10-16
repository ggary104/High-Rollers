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
