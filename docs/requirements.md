# CSCI 265 Requirements and specifications (Phase 2)

## Team name: The High Rollers

## Project/product name: High ROllers

## Contact person and email 

The following person has been designated the main contact person for questions from the reader:

 - Seth, seth.william.doyle@gmail.com

This document describes the requirements and specifications for *High Rollers*, a two-mode dice strategy game developed using Godot 4. It includes gameplay descriptions, user interface specifications, non-functional requirements, and prioritized features for Phase 2 of the project.

## Table of Contents
1. [Introduction and Overview](#1-introduction-and-overview)  
2. [Product Features and Behaviour](#2-product-features-and-behaviour)  
3. [User Interface and Navigation](#3-user-interface-and-navigation)  
4. [Non-Functional Requirements](#4-non-functional-requirements)  
5. [Use Cases](#5-use-cases)  
6. [Prioritized Feature Set](#6-prioritized-feature-set)  
7. [Glossary](#7-glossary)  
8. [Appendix A – File and Folder Structure](#appendix-a-file-and-folder-structure)  

## Introduction and overview

**Project Summary**  
*High Rollers* is a competitive two-player dice game with both *Classic* and *Hot Dice* modes. Players take turns rolling dice to strategically fill a 3×3 grid. The game emphasizes luck, spatial reasoning, and tactical decision-making.

**Target Platform**  
- Desktop (Windows/macOS/Linux) using Godot 4 engine  
- Mouse or touch-based interaction  

**Assumptions**  
- Players understand basic dice mechanics.  
- Devices support standard 16:9 resolutions.  
- Internet connection is not required.  
- No save/load functionality is necessary for single-session play.  

**Known Limitations**  
- Multiplayer is local-only.  
- Limited sound effects.  
- Accessibility features (such as color-blind mode) are not included in this phase.  

---

## 2. Product Features and Behaviour

### 2.1 Main Menu
- The player shall be presented with the following options:  
  - **Play** (launches game mode selection screen)  
  - **How to Play** (shows gameplay instructions)  
  - **Quit** (closes the application)

### 2.2 Mode Selection
- Upon selecting *Play*, the player shall choose between:  
  - **Classic Mode** – basic 3×3 dice grid battle  
  - **Hot Dice Mode** – dice combat with health points (HP)

### 2.3 Classic Mode Gameplay
- Players shall take turns rolling a die.  
- Each roll shall yield a value from 1–6.  
- The player shall place the die value into one of the 9 grid cells.  
- The opposing player’s corresponding column or row shall react (score modification based on matching rules).  
- The game shall end when either player’s grid is filled.  
- The winner shall be the player with the higher total score.

### 2.4 Hot Dice Mode Gameplay
- Each player shall begin with **100 HP**.  
- Dice rolls shall be placed on a 3×3 grid, similar to Classic Mode.  
- When a row or column is completed, a “Cash In” can be triggered, dealing damage based on accumulated values.  
- The player shall lose if their HP reaches 0.  

### 2.5 Scoring
- Scores shall update dynamically after each placement.  
- Combo multipliers shall be applied when rows or columns contain matching numbers.  
- “Cash In” shall reduce the opponent’s HP by the calculated total.  

### 2.6 End Conditions
- **Classic Mode:** Game ends when all grid cells are filled.  
- **Hot Dice Mode:** Game ends when one player’s HP reaches 0.  
- A results screen shall display winner, final score, and play again/quit options.  

---

## 3. User Interface and Navigation

### 3.1 Main Menu Layout
```
-------------------------------------
|           HIGH ROLLERS            |
|-----------------------------------|
|  [Play]     [How to Play]     [Quit] |
-------------------------------------
```

### 3.2 Game Screen Layout (Classic Mode)
```
-------------------------------------
|  Player 1 Grid   |   Player 2 Grid |
|  3×3 cells each   |   mirrored view |
|-----------------------------------|
|   [Roll]   [Undo]   [End Turn]    |
-------------------------------------
```

### 3.3 Game Screen Layout (Hot Dice Mode)
```
-------------------------------------
| P1 HP: 100          P2 HP: 100     |
|   3×3 Grids + HP bars display      |
|-----------------------------------|
|  [Roll]  [Cash In]  [End Turn]    |
-------------------------------------
```

### 3.4 Navigation Rules
- ESC key shall return to the previous screen.  
- Clicking the in-game menu icon shall pause gameplay and show: *Resume*, *Restart*, *Quit*.  

---

## 4. Non-Functional Requirements

| Requirement | Description |
|--------------|-------------|
| **Performance** | Each turn update shall process within 0.2 seconds. |
| **Usability** | All menu options shall be accessible via mouse or keyboard. |
| **Portability** | The game shall run on any OS supported by Godot 4. |
| **Maintainability** | Code shall follow the GDScript style guide. |
| **Reliability** | Game logic shall remain consistent regardless of frame rate. |
| **Aesthetics** | Simple 2D UI with clean layout and dice animations. |

---

## 5. Use Cases

### 5.1 Use Case: Play a Game in Classic Mode

**Primary Actor:** Player  
**Preconditions:** Game is launched and user is on the main menu.  
**Main Flow:**  
1. The player selects *Play → Classic Mode*.  
2. The game board initializes with empty 3×3 grids.  
3. Player 1 clicks *Roll*.  
4. A die animation plays and shows a random number (1–6).  
5. The player clicks a cell to place the die value.  
6. Player 2 repeats the process.  
7. When both grids are filled, the game computes scores.  
8. Results screen displays winner and score.  

**Postconditions:** Game state resets or player returns to main menu.  

---

### 5.2 Use Case: Hot Dice Combat Round

**Primary Actor:** Player  
**Preconditions:** Player selects *Play → Hot Dice Mode*.  
**Main Flow:**  
1. The game displays HP bars for both players.  
2. Player 1 rolls and places a die.  
3. Once a row or column is filled, *Cash In* becomes available.  
4. Player activates *Cash In* to damage opponent.  
5. If HP ≤ 0, results screen declares the winner.  

**Postconditions:** Player can replay or quit to the main menu.  

---

## 6. Prioritized Feature Set

| Priority | Feature | Description |
|-----------|----------|-------------|
| High | Classic Mode Gameplay | Core turn-based 3×3 dice battle |
| High | Hot Dice Mode | Adds HP and combat system |
| Medium | Dice Animations | Visual feedback for rolls |
| Medium | Sound Effects | Rolling and damage sounds |
| Medium | Scoring UI | Displays score dynamically |
| Low | Menu Music | Background theme |
| Low | Save System | Future enhancement |

---

## 7. Glossary

| Term | Definition |
|------|-------------|
| Die (Dice) | Six-sided object producing values 1–6 |
| Grid | 3×3 layout where dice are placed |
| Hot Dice | Game mode with HP and combat mechanics |
| Classic Mode | Game mode focused on score-based play |
| Cash In | Action to convert accumulated dice into HP damage |
| HP | Health Points |
| AI | Computer-controlled opponent |
| GameManager | Godot node managing game state |

---

## Appendix A – File and Folder Structure


