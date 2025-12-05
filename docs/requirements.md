# CSCI 265 Requirements and Specifications

## Team name: Dice Destroyers

## Project/product name: High Rollers

## Contact person and email

Seth William Doyle, seth.william.doyle@gmail.com

---

# Table of Contents

1. [Known Issues and Omissions](#section1)
2. [Game Overview](#section2)
3. [Target Audience and Platform Requirements](#section3)
4. [Game Flow and Objectives](#section4)
5. [Key Features with Detailed Requirements](#section5)
6. [Game Interface, Screens, and Menus](#section6)
7. [Feature Prioritization](#section7)
8. [Non-Functional Requirements](#section8)
9. [Use Cases and Scenarios](#section9)
10. [Glossary](#section10)

# List of Figures

A. [Main Menu Screen](#fig_mainmenu)  
B. [Options Menu Screen](#fig_optionsmenu)  
C. [Classic Mode Game Screen](#fig_classic)  
D. [Hot Dice Mode Game Screen](#fig_hotdice)  
E. [Game Over Screen](#fig_gameover)  
F. [Navigation Flow Diagram](#fig_navigation)

---

## 1. Known Issues and Omissions <a name="section1"></a>

The following items are known limitations or incomplete elements in this requirements document:

**Incomplete Elements:**
- Detailed wireframes and mockups for all screens are described but not yet rendered as final images
- Sound effect specifications (specific audio files, formats, and volume levels) are not yet determined
- Exact visual styling (colors beyond grayscale, fonts, button styles) will be finalized during Phase 3 design
- Computer AI strategy for Hot Dice mode is currently simplified (random placement); enhanced AI is a secondary goal

**Future Enhancements to be Specified:**
- Online multiplayer networking specifications (currently local-only)
- Player profile and statistics tracking system
- Tournament bracket system details
- Power-up and coin economy mechanics
- Difficulty progression system

**Documentation Dependencies:**
- User manual content will be developed in Phase 3
- Detailed glossary terms will be expanded based on user guide terminology
- Test cases and acceptance criteria will be documented in Phase 4 test plan

---

## 2. Game Overview <a name="section2"></a>

### 2.1 Product Summary

High Rollers is a competitive two-player strategic dice game developed using the Godot 4.5 game engine. The game offers two distinct modes—Classic Mode and Hot Dice Mode—each providing unique win conditions and gameplay mechanics. Players take turns rolling six-sided dice and strategically placing them on 3×3 grids to maximize scores or deal damage to opponents.

**Core Gameplay Loop:**
1. Player rolls a six-sided die (result: 1-6)
2. Player places die on their 3×3 grid
3. Destruction mechanic: Opponent's matching dice in same row are removed
4. Score updates based on multiplier formula
5. Turn passes to opponent
6. Repeat until win condition met

### 2.2 Game Modes

**Classic Mode:**
- **Objective:** Achieve the highest score when either player's grid is completely filled
- **Win Condition:** Board full (9 spaces) for either player, highest score wins
- **Key Mechanic:** Column-based placement with row destruction
- **Duration:** Approximately 5-10 minutes per game

**Hot Dice Mode:**
- **Objective:** Reduce opponent's health to zero
- **Win Condition:** Opponent reaches 0 HP
- **Key Mechanic:** Grid-based placement with "Cash In" damage system
- **Special Feature:** Dice value 1 provides healing when destroyed
- **Duration:** Approximately 10-15 minutes per game

### 2.3 Unique Selling Points

1. **Dual-Mode Gameplay:** Two distinct game modes within one application
2. **Strategic Depth:** Multiplier scoring creates complex decision-making
3. **Destruction Mechanic:** Offensive capabilities through dice elimination
4. **Accessible:** Simple rules with deep strategic implications
5. **Quick Sessions:** Games complete in 5-15 minutes

---

## 3. Target Audience and Platform Requirements <a name="section3"></a>

### 3.1 Target Audience

**Primary Audience:**
- Age range: 12+ years
- Casual to intermediate board game enthusiasts
- Players who enjoy tactical, turn-based games
- Fans of dice games (Yahtzee, King of Tokyo, Splendor)
- Groups seeking quick, competitive local multiplayer experiences

**Player Characteristics:**
- Comfortable with basic math (addition, multiplication)
- Familiar with digital interfaces and touch/mouse controls
- Interested in games with balanced luck and strategy
- Seeking replayable content with minimal learning curve

**Use Context:**
- Local multiplayer sessions with friends or family
- Casual gaming sessions during breaks
- Competitive play between skilled players
- Educational settings (probability, strategic thinking)

### 3.2 Platform and Technical Requirements

**Target Platforms:**

| Platform | Minimum Requirements | Optimal Requirements |
|----------|---------------------|----------------------|
| **Windows** | Windows 10 64-bit, 4GB RAM, 200MB storage | Windows 11, 8GB RAM, dedicated GPU |
| **macOS** | macOS 10.15 Catalina, 4GB RAM, 200MB storage | macOS 13+, 8GB RAM, Apple Silicon |
| **Linux** | Ubuntu 20.04+, 4GB RAM, 200MB storage | Ubuntu 22.04+, 8GB RAM |
| **Android** | Android 6.0 (API 23), 2GB RAM | Android 12+, 4GB RAM |
| **iOS** | iOS 12+, 2GB RAM | iOS 16+, 3GB RAM |

**Display Requirements:**
- **Minimum Resolution:** 1280×720 (720p)
- **Optimal Resolution:** 1600×900 or 1920×1080 (1080p)
- **Aspect Ratio:** 16:9 (will stretch other ratios using canvas_items mode)
- **Orientation:** Landscape only
- **Color Depth:** 24-bit or higher

**Input Methods:**
- **Desktop:** Mouse (left-click only)
- **Mobile:** Touch (single-touch, no multi-touch required)
- **Keyboard:** Not required (optional ESC key for future pause functionality)

**Performance Targets:**
- **Frame Rate:** 60 FPS (minimum 30 FPS)
- **Load Time:** < 3 seconds from launch to main menu
- **Turn Processing:** < 200ms from input to state change
- **Memory:** < 200MB RAM during active gameplay

**Dependencies:**
- **Engine:** Godot 4.5 or higher
- **Rendering:** OpenGL ES 3.0 / Vulkan support
- **Audio:** Not required for Phase 1 (silent gameplay acceptable)
- **Network:** Not required (local-only)

### 3.3 Assumptions and Limitations

**Assumptions:**
- Players understand basic dice mechanics (1-6 values, random outcomes)
- Players can perform basic arithmetic operations
- Single-device local multiplayer (no separate devices required)
- Internet connection is not required at any point
- Players can read English text (no localization in Phase 1)

**Known Limitations:**
- No online multiplayer functionality
- No mid-game save/load capability
- AI opponent uses simplified strategy (not human-level difficulty)
- Limited sound effects and music (Phase 1 priority is silent gameplay)
- No accessibility features (color-blind mode, screen readers, etc.)
- No tutorial or interactive how-to-play guide in initial version
- Portrait orientation not supported on mobile

---

## 4. Game Flow and Objectives <a name="section4"></a>

### 4.1 Application Launch Sequence

When the application is launched, the following initialization occurs:

1. **Engine Initialization** (< 1 second)
   - Godot engine loads core systems
   - GameManager singleton initializes with default values:
     - `gameMode = ""` (empty string)
     - `playerNumber = 1` (default)
     - `winner_text = ""` (empty string)
   - SceneManager singleton initializes
   - Window configured to 1600×900 viewport

2. **Main Menu Load** (< 2 seconds total from launch)
   - Main menu scene (`main_menu.tscn`) loads
   - UI elements rendered:
     - Title: "High Rollers" (48pt font)
     - Two buttons: "Hot Dice" and "Classic" (24pt font each)
   - Background color set to dark gray (RGB: 40, 43, 48)
   - Buttons become interactive

3. **Ready State**
   - Application waits for player input
   - No automatic progression or timers
   - Memory footprint stabilized < 100MB

### 4.2 Game Mode Selection Flow

**Player Actions:**

```
Launch Application
    ↓
Main Menu Displayed
    ↓
Player clicks "Hot Dice" OR "Classic"
    ↓
GameManager.gameMode set to "game" OR "classic"
    ↓
Transition to Options Menu (player selection)
    ↓
Player clicks "One Player" OR "Two Player"
    ↓
GameManager.playerNumber set to 1 OR 2
    ↓
Load selected game scene (game.tscn OR classic.tscn)
    ↓
Game Initializes and First Turn Begins
```

**State Persistence:**
- `GameManager.gameMode` persists throughout session
- `GameManager.playerNumber` persists throughout session
- Values reset only on application restart
- Scene transitions do not clear these values

### 4.3 Turn-Based Game Loop

Both game modes follow a consistent turn structure:

**Turn Phases:**

1. **Turn Start Phase**
   - Current player determined (player_turn = 1 or 2)
   - UI updates to show active player
   - Roll button becomes visible for active player
   - Opponent's controls disabled

2. **Roll Phase**
   - Player clicks "Roll" button
   - Random value generated: `randi() % 6 + 1` (result: 1, 2, 3, 4, 5, or 6)
   - Die sprite displayed with rolled value
   - Roll button disabled
   - Placement phase begins

3. **Placement Phase**
   - **Classic Mode:** Player clicks one of 3 column buttons
   - **Hot Dice Mode:** Player clicks any empty tile in their 3×3 grid
   - Die placed at selected location
   - Destruction mechanic triggered (if applicable)
   - Placement phase ends

4. **Resolution Phase**
   - Scores recalculated using multiplier formula
   - UI labels updated with new scores
   - Win condition checked
   - If game continues, proceed to Turn End
   - If game over, transition to Game Over screen

5. **Turn End Phase**
   - `player_turn` switches (1→2 or 2→1)
   - Current die reference set to null
   - Next player's turn begins (return to Turn Start Phase)

### 4.4 Win Conditions

**Classic Mode Win Conditions:**

Game ends when **either** player's 3×3 grid is completely filled (all 9 spaces occupied).

**Winner Determination Process:**
1. Detect that any player has 9 occupied spaces
2. Calculate final scores for both players:
   - Player 1: Sum of all 3 row scores
   - Player 2: Sum of all 3 row scores
3. Compare scores:
   - If P1 score > P2 score: "Player 1 Wins!"
   - If P2 score > P1 score: "Player 2 Wins!"
   - If scores equal: "Its a draw!" (note: intentional grammar as per code)
4. Set `GameManager.winner_text` to result string
5. Transition to Game Over scene

**Hot Dice Mode Win Conditions:**

Game ends when **either** player's HP reaches 0 or below.

**Winner Determination Process:**
1. After each Cash In action, check both HP values
2. If Player 1 HP ≤ 0: Set `GameManager.winner_text = "Player 2 Wins!"`
3. If Player 2 HP ≤ 0: Set `GameManager.winner_text = "Player 1 Wins!"`
4. Immediately transition to Game Over scene
5. No draw possible in Hot Dice mode

---

## 5. Key Features with Detailed Requirements <a name="section5"></a>

### 5.1 Dice Rolling Mechanic

**Requirement ID:** FR-DICE-001

**Description:** Generate random die values for player actions

**Implementation Details:**
- **Random Number Generation:** `randi() % 6 + 1`
- **Possible Values:** 1, 2, 3, 4, 5, 6 (inclusive)
- **Distribution:** Uniform distribution (each value has 1/6 probability)
- **Seed:** System time-based seed initialized at game start: `srand(time(NULL))`
- **Trigger:** Player clicks "Roll" button during their turn
- **Frequency:** Once per turn, cannot re-roll
- **Visual Feedback:** Die sprite updates to show rolled value

**Functional Requirements:**
- FR-DICE-001.1: System shall generate exactly one random integer from 1-6 when Roll button clicked
- FR-DICE-001.2: Generated value shall be immediately displayed as die sprite in designated position
- FR-DICE-001.3: Roll button shall become disabled after single use per turn
- FR-DICE-001.4: Value shall persist until placed or turn ends
- FR-DICE-001.5: System shall not allow re-rolling within same turn

**Error Handling:**
- If roll generates value outside 1-6 range: Log error, default to value 3
- If roll button clicked when already rolled: No effect (button disabled)
- If roll called with invalid player turn: Log error, ignore action

### 5.2 Grid System (3×3 Board)

**Requirement ID:** FR-GRID-001

**Description:** Manage 3×3 grid for dice placement

**Grid Structure:**
- **Dimensions:** 3 columns × 3 rows = 9 total spaces
- **Indexing:** 
  - Rows: 0, 1, 2 (bottom to top in Classic; standard 0-2 in Hot Dice)
  - Columns: 0, 1, 2 (left to right)
- **Data Storage:** 
  - Classic Mode: 2D array `[[col0_row0, col0_row1, col0_row2], [col1...], [col2...]]`
  - Hot Dice Mode: 2D array `[[row0_col0, row0_col1, row0_col2], [row1...], [row2...]]`
- **Empty Space Representation:** Value = 0
- **Occupied Space:** Value = 1-6 (die face value)

**Grid Properties Per Player:**

| Property | Value | Description |
|----------|-------|-------------|
| Total Spaces | 9 | Fixed size, cannot expand |
| Empty Indicator | 0 | Zero means space available |
| Minimum Die Value | 1 | Smallest possible die |
| Maximum Die Value | 6 | Largest possible die |
| Columns | 3 | Vertical divisions |
| Rows | 3 | Horizontal divisions |

**Functional Requirements:**
- FR-GRID-001.1: Each player shall have independent 3×3 grid
- FR-GRID-001.2: Empty spaces shall be represented by integer value 0
- FR-GRID-001.3: Occupied spaces shall contain die value (1-6)
- FR-GRID-001.4: System shall prevent placement on occupied spaces
- FR-GRID-001.5: Grid state shall persist throughout game session
- FR-GRID-001.6: Grid shall be clearable only via Cash In action (Hot Dice) or game restart

**Visual Requirements:**
- FR-GRID-001.7: Classic Mode grids rotated 90° counterclockwise for visual layout
- FR-GRID-001.8: Hot Dice Mode grids displayed in standard orientation
- FR-GRID-001.9: Each grid space shall visually display die texture when occupied
- FR-GRID-001.10: Empty spaces shall display placeholder texture or transparent background

### 5.3 Dice Placement System

**Requirement ID:** FR-PLACE-001

**Description:** Allow players to place rolled dice on their grid

**Classic Mode Placement:**

**Input Method:** Column buttons (3 large clickable areas behind grid)

**Placement Logic:**
1. Player clicks one of 3 column buttons (indices 0, 1, or 2)
2. System searches column array from bottom to top (indices 0→2)
3. First empty space (value = 0) is filled with die value
4. If no empty space found, placement has no effect (silently ignored)

**Column Fill Order Example:**
```
Column 0: [0, 0, 0]  // All empty
Player places 6 in column 0
Column 0: [6, 0, 0]  // First slot (index 0) filled

Player places 3 in column 0
Column 0: [6, 3, 0]  // Second slot (index 1) filled

Player places 2 in column 0
Column 0: [6, 3, 2]  // Third slot (index 2) filled, column FULL
```

**Hot Dice Mode Placement:**

**Input Method:** Direct tile clicking (9 individual clickable tiles)

**Placement Logic:**
1. Player clicks any tile in their 3×3 grid
2. System checks if selected tile is empty (value = 0)
3. If empty: Die value placed at exact clicked position
4. If occupied: Click has no effect (silently ignored)
5. No fill-order constraints; player chooses exact position

**Tile Click Example:**
```
Grid: [[0,0,0], [0,0,0], [0,0,0]]  // All empty
Player clicks tile at row=1, col=2
Player places 5
Grid: [[0,0,0], [0,0,5], [0,0,0]]  // Exact position filled
```

**Functional Requirements:**
- FR-PLACE-001.1: System shall only allow placement during current player's turn
- FR-PLACE-001.2: System shall only allow placement after die has been rolled
- FR-PLACE-001.3: Classic Mode shall fill columns bottom-to-top automatically
- FR-PLACE-001.4: Hot Dice Mode shall place at exact clicked tile location
- FR-PLACE-001.5: System shall ignore clicks on occupied spaces
- FR-PLACE-001.6: Placement action shall trigger destruction mechanic check
- FR-PLACE-001.7: Single placement action per roll (cannot place same die multiple times)

**Validation Rules:**
- Placement only valid if:
  - Current player's turn is active (`player_turn` matches placing player)
  - Die has been rolled (`current_roll > 0` or `current_dice != null`)
  - Target space is empty (value = 0)
  - Game is not over (`game_over == false`)

### 5.4 Dice Destruction Mechanic

**Requirement ID:** FR-DESTROY-001

**Description:** Remove opponent dice when matching values placed in same row

**Trigger:** Immediately after player places die on their grid

**Destruction Logic:**

**Step-by-Step Process:**
1. Player places die with value V in row R, column C
2. System identifies opponent's corresponding row R
3. System scans opponent's row R for all dice matching value V
4. For each matching die found:
   - Remove die from opponent's grid (set value to 0)
   - Destroy die visual object (sprite removed from scene)
   - Shift remaining dice down to fill gaps (maintain bottom-to-top order)
5. Update opponent's score display

**Row Correspondence:**
- Row indices are consistent across both players
- Placing in Player 1 Row 0 affects Player 2 Row 0
- Placing in Player 1 Row 1 affects Player 2 Row 1
- Placing in Player 1 Row 2 affects Player 2 Row 2

**Multiple Matches Handling:**
- If opponent has multiple dice with same value in target row, **all** are destroyed
- Example: Opponent has [4, 4, 2] in row 1. Player places 4 in row 1. Result: Opponent row becomes [2, 0, 0]

**Gap Filling After Destruction:**

Classic Mode (Column-based):
```
Before: Opponent Column 1: [6, 4, 2]  // Row indices 0,1,2
Player places 4 in row 1 of their own grid
After:  Opponent Column 1: [6, 2, 0]  // 4 removed, remaining dice shift up
```

Hot Dice Mode (Exact positions):
```
Before: Opponent Row 1: [0, 4, 6]  // Col indices 0,1,2
Player places 4 in their Row 1
After:  Opponent Row 1: [0, 0, 6]  // 4 at col 1 removed, no shifting
```

**Functional Requirements:**
- FR-DESTROY-001.1: System shall check for matches immediately after placement
- FR-DESTROY-001.2: System shall remove **all** matching dice from opponent's row
- FR-DESTROY-001.3: Destruction shall only affect opponent, never same player
- FR-DESTROY-001.4: System shall maintain data consistency (array values match visuals)
- FR-DESTROY-001.5: Destroyed dice shall be removed from display within 0.1 seconds

**Special Cases:**
- If no matching dice in opponent's row: No destruction occurs
- If opponent's row is empty: No destruction possible
- If player's own row has matching dice: No self-destruction (only opponent affected)

### 5.5 Scoring System with Multipliers

**Requirement ID:** FR-SCORE-001

**Description:** Calculate scores based on dice values with multiplier for matching dice

**Scoring Formula:**

For each row in a player's grid:
```
row_score = 0
For each unique die value V in row:
    count = number of dice with value V in this row
    row_score += (count × V × count)

total_score = sum of all 3 row scores
```

**Formula Breakdown:**
- `count`: How many dice of same value in row
- `V`: The die face value (1-6)
- Multiplier: `count × count` (squared quantity)
- Contribution: `count × V × count` = quantity × value × quantity

**Scoring Examples:**

**Example 1: Single Dice**
```
Row: [6, 0, 0]
count(6) = 1
score = 1 × 6 × 1 = 6 points
```

**Example 2: Two Matching Dice**
```
Row: [5, 5, 0]
count(5) = 2
score = 2 × 5 × 2 = 20 points
```

**Example 3: Three Matching Dice**
```
Row: [4, 4, 4]
count(4) = 3
score = 3 × 4 × 3 = 36 points
```

**Example 4: Mixed Dice**
```
Row: [6, 6, 3]
count(6) = 2, count(3) = 1
score = (2 × 6 × 2) + (1 × 3 × 1) = 24 + 3 = 27 points
```

**Example 5: Three Different Dice**
```
Row: [6, 5, 2]
count(6) = 1, count(5) = 1, count(2) = 1
score = (1×6×1) + (1×5×1) + (1×2×1) = 6 + 5 + 2 = 13 points
```

**Complete Board Scoring Example:**
```
Player Grid:
Row 0: [6, 6, 3]  → 27 points
Row 1: [5, 5, 5]  → 45 points
Row 2: [2, 4, 4]  → 18 points

Total Score: 27 + 45 + 18 = 90 points
```

**Scoring Properties Table:**

| Quantity | Die Value | Individual Contribution | Notes |
|----------|-----------|------------------------|-------|
| 1 die | 1 | 1×1×1 = 1 | Minimum possible |
| 1 die | 6 | 1×6×1 = 6 | Single die maximum |
| 2 matching | 1 | 2×1×2 = 4 | 4× better than single 1 |
| 2 matching | 6 | 2×6×2 = 24 | 4× better than single 6 |
| 3 matching | 1 | 3×1×3 = 9 | 9× better than single 1 |
| 3 matching | 6 | 3×6×3 = 54 | 9× better than single 6, MAXIMUM |

**Functional Requirements:**
- FR-SCORE-001.1: Scores shall recalculate immediately after every die placement
- FR-SCORE-001.2: Scores shall update after every dice destruction
- FR-SCORE-001.3: Score calculation shall use exact formula: count × value × count
- FR-SCORE-001.4: Empty spaces (value 0) shall not contribute to score
- FR-SCORE-001.5: Each row shall be scored independently
- FR-SCORE-001.6: Total score shall be sum of all 3 row scores
- FR-SCORE-001.7: Score display shall update within 0.1 seconds of placement
- FR-SCORE-001.8: Scores shall be displayed as integer values (no decimals)

**Display Requirements:**
- Score labels show format: "P1 Score: XXX" and "P2 Score: XXX"
- Font size: 23pt
- Updates every frame after state change
- Both scores always visible during gameplay

### 5.6 Health Point (HP) System (Hot Dice Mode Only)

**Requirement ID:** FR-HP-001

**Description:** Track player health and manage damage/healing

**Health Constants:**

| Constant | Value | Description |
|----------|-------|-------------|
| MAX_HEALTH | 100 | Starting and maximum HP |
| MIN_HEALTH | 0 | Minimum HP (game over) |
| STARTING_HP | 100 | Both players begin at full |

**HP Initialization:**
```gdscript
const MAX_HEALTH: int = 100
var player1_health: int = MAX_HEALTH  // 100
var player2_health: int = MAX_HEALTH  // 100
```

**HP Modification Rules:**
- HP can decrease through Cash In damage
- HP can increase through healing (dice 1 destruction)
- HP cannot exceed MAX_HEALTH (100)
- HP cannot go below MIN_HEALTH (0)
- HP clamping: `player_health = max(0, player_health)`

**Cash In Damage System:**

**Process:**
1. Current player clicks "Cash In" button
2. System calculates player's total board score (using multiplier formula)
3. Calculated score subtracted from opponent's HP
4. Opponent HP clamped to minimum 0
5. Damage animation plays (health bar flashes red)
6. All dice cleared from current player's board
7. If opponent HP = 0, game over triggered

**Cash In Example:**
```
Player 1 Board State:
Row 0: [6,6,6]  → 54 points
Row 1: [5,5,0]  → 20 points
Row 2: [3,0,0]  → 3 points
Total: 77 points

Player 2 HP before: 82
Action: Player 1 clicks Cash In
Damage dealt: 77
Player 2 HP after: 82 - 77 = 5

Player 1's board clears to [[0,0,0],[0,0,0],[0,0,0]]
```

**Healing System (Dice Value 1 Special Effect):**

**Trigger:** When a die showing value 1 is **destroyed** by opponent's placement

**Process:**
1. Opponent places die matching value 1 in row containing player's 1
2. Player's die (value 1) is destroyed per normal destruction rules
3. **Additional effect:** Owner of destroyed 1 gains +1 HP
4. HP clamping applied (cannot exceed 100)
5. Green flash animation plays on owner's health bar
6. Healing only applies to destruction, not Cash In clearing

**Healing Example:**
```
Player 1 HP: 45/100
Player 1 Board Row 0: [1, 5, 0]
Player 2 places 1 in their Row 0
Result: Player 1's die (value 1) destroyed
Effect: Player 1 HP increases 45 → 46
```

**Healing Edge Cases:**
- If player at 100 HP and 1 destroyed: HP remains 100 (no overflow)
- Multiple 1s in row destroyed simultaneously: +1 HP per die
  - Example: Row has [1,1,0], opponent places 1 → both destroyed → +2 HP total
- Healing applies only when destroyed by opponent, not by own Cash In

**HP Display Requirements:**
- FR-HP-001.10: Health bars shall display at bottom of screen
- FR-HP-001.11: Health bar width shall scale proportionally to current/max HP
- FR-HP-001.12: Health bar fill color: White (default), Red (damage), Green (heal)
- FR-HP-001.13: Progress bar component: `ProgressBar.value = current_hp`
- FR-HP-001.14: Progress bar max value set to 100
- FR-HP-001.15: HP changes shall animate within 0.2 seconds

**Functional Requirements:**
- FR-HP-001.1: Both players start at exactly 100 HP
- FR-HP-001.2: HP shall only decrease via Cash In action
- FR-HP-001.3: HP shall only increase via dice-1-destruction healing
- FR-HP-001.4: HP shall be clamped to range [0, 100] at all times
- FR-HP-001.5: Reaching 0 HP shall immediately trigger game over
- FR-HP-001.6: HP values shall be stored as integers (no fractional HP)
- FR-HP-001.7: Damage animation shall play when HP decreases
- FR-HP-001.8: Heal animation shall play when HP increases
- FR-HP-001.9: HP state shall persist throughout game session

### 5.7 Cash In Action (Hot Dice Mode Only)

**Requirement ID:** FR-CASHIN-001

**Description:** Convert accumulated board score into opponent HP damage

**Activation Requirements:**

Player can Cash In if ALL of the following are true:
- Current player's turn is active
- At least one die exists on current player's board
- No die is currently rolled and awaiting placement
  - `current_dice == null` must be true
- Game is not over

**Cash In Button States:**

| Condition | Button Visibility | Button Enabled |
|-----------|------------------|----------------|
| Player's turn, has dice, no roll pending | Visible | Enabled |
| Opponent's turn | Hidden | N/A |
| Player's turn, board empty | Visible | Disabled |
| Player's turn, die rolled but not placed | Visible | Disabled |

**Cash In Process (Step-by-Step):**

1. **Validation Phase:**
   - Verify it's current player's turn
   - Verify current_dice is null (no pending placement)
   - Verify at least one non-zero value in player's grid
   - If any check fails: Ignore button click, no effect

2. **Score Calculation Phase:**
   - Calculate Row 0 score using multiplier formula
   - Calculate Row 1 score using multiplier formula
   - Calculate Row 2 score using multiplier formula
   - Total score = sum of all 3 rows

3. **Damage Application Phase:**
   - Subtract total score from opponent's HP
   - Clamp opponent HP to minimum 0: `opponent_hp = max(0, opponent_hp)`

4. **Animation Phase:**
   - Create tween animation on opponent health bar
   - Flash health bar red for 0.2 seconds
   - Flash back to white for 0.2 seconds
   - Total animation duration: 0.4 seconds
   - Update health bar value immediately (doesn't wait for animation)

5. **Board Clear Phase:**
   - Set all grid positions to 0: `[[0,0,0],[0,0,0],[0,0,0]]`
   - Remove all die visual objects from current player's grid
   - Play destruction animations for each die
   - Clear dice references from grid tiles

6. **Win Condition Check:**
   - Check if opponent HP ≤ 0
   - If true: Set game_over flag, transition to Game Over screen
   - If false: Continue to Turn Switch Phase

7. **Turn Switch Phase:**
   - Switch active player (1→2 or 2→1)
   - Update turn indicator label
   - Enable new player's controls
   - Disable previous player's controls

**Computer AI Cash In Behavior:**

When player_number = 1 (vs AI), computer has Cash In logic:
- **Always Cash In:** If board is completely full (9/9 spaces)
- **Probabilistic Cash In:** 30% chance each turn if score > 0
- **Random Number Check:** `randf() < 0.3` determines if AI cashes in
- **Display Message:** "Computer Cashed In!" shown for 1.2 seconds before action

**Functional Requirements:**
- FR-CASHIN-001.1: Cash In shall only be available during current player's turn
- FR-CASHIN-001.2: Cash In shall require at least one die on board
- FR-CASHIN-001.3: Cash In shall be blocked if die awaiting placement
- FR-CASHIN-001.4: Damage calculation shall use exact multiplier scoring formula
- FR-CASHIN-001.5: Damage shall apply immediately (not turn-end)
- FR-CASHIN-001.6: All dice shall be removed from current player's board
- FR-CASHIN-001.7: Turn shall switch after Cash In completes
- FR-CASHIN-001.8: Animation shall provide clear visual feedback
- FR-CASHIN-001.9: AI shall have 30% probabilistic Cash In behavior

**Cash In Complete Example:**
```
Turn: Player 1
Player 1 Board: [[6,6,6],[5,5,0],[4,0,0]]
Player 1 Score: 54+20+4 = 78 points
Player 2 HP: 100

Player 1 clicks "Cash In"
→ 78 damage dealt to Player 2
→ Player 2 HP: 100 - 78 = 22
→ Red flash animation on Player 2 health bar
→ Player 1 board clears to [[0,0,0],[0,0,0],[0,0,0]]
→ All dice visuals destroyed
→ Turn switches to Player 2
→ Player 2 HP remains at 22 for their turn
```

### 5.8 Computer AI (Opponent) Behavior

**Requirement ID:** FR-AI-001

**Description:** Computer-controlled opponent behavior for single-player mode

**AI Activation:**
- AI controls Player 2 when `GameManager.playerNumber == 1`
- AI does not control any player when `GameManager.playerNumber == 2`

**Classic Mode AI (Strategic):**

The Classic Mode AI uses a scoring-based decision system:

**Column Evaluation Scoring:**

For each of the 3 columns, AI calculates a score based on:

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Column Full | -100 | All 3 spaces occupied (column[2] ≠ 0) |
| Empty Space | +1 per empty | Each space with value 0 |
| Matching Die | +10 | Column contains die matching current roll |
| Opponent Destroy | +4 | Opponent row contains die matching current roll |

**Scoring Algorithm:**
```python
for each column (0, 1, 2):
    if column is full:
        score[column] = -100
        continue
    
    score[column] = 0
    
    # Count empty spaces
    for space in column:
        if space == 0:
            score[column] += 1
    
    # Check for matching dice (for multiplier bonus)
    for die in column:
        if die == current_roll:
            score[column] += 10
    
    # Check opponent's corresponding row for destruction
    for die in opponent_column:
        if die == current_roll:
            score[column] += 4

# Select column with highest score
best_column = column with max(score[0], score[1], score[2])

# If tie: randomly choose among tied columns
```

**AI Decision Examples:**

**Scenario 1: Prioritize Matching Dice**
```
Current Roll: 5
AI Column States:
- Column 0: [5, 3, 0]  → Score: 1 (empty) + 10 (match) = 11
- Column 1: [6, 6, 2]  → Score: -100 (full)
- Column 2: [2, 0, 0]  → Score: 2 (empties) = 2

Decision: Choose Column 0 (highest score: 11)
Reasoning: Matching die provides multiplier opportunity
```

**Scenario 2: Prioritize Destruction**
```
Current Roll: 6
AI Column States:
- Column 0: [3, 0, 0]  → Score: 2 (empties) = 2
- Column 1: [5, 0, 0]  → Score: 2 (empties) = 2
- Column 2: [4, 0, 0]  → Score: 2 (empties) = 2

Opponent Row States:
- Opponent Row 0: [6, 2, 0]  → Has 6 (match)
- Opponent Row 1: [3, 3, 0]  → No match
- Opponent Row 2: [5, 0, 0]  → No match

Adjusted Scores:
- Column 0: 2 + 4 (destroy) = 6
- Column 1: 2
- Column 2: 2

Decision: Choose Column 0 (destroy opponent's 6)
```

**AI Timing (Classic Mode):**
- Delay before roll: 0.5 seconds
- Display rolled die: immediate
- Delay before placement: 0.5 seconds
- Total AI turn duration: ~1.0 seconds minimum

**Hot Dice Mode AI (Simplified Random):**

Hot Dice AI uses random tile selection:

**Random Placement Algorithm:**
```python
function get_random_tile():
    random_x = randi() % 3  # 0, 1, or 2
    random_y = randi() % 3  # 0, 1, or 2
    
    if grid[random_y][random_x] == 0:  # Empty
        return Vector2i(random_x, random_y)
    else:  # Occupied, try again recursively
        return get_random_tile()
```

**AI Cash In Decision (Hot Dice):**
- **Always Cash In:** If grid completely full (9/9 spaces)
- **Random Cash In:** 30% probability at turn start if any dice on board
- **Random Check:** `randf() < 0.3` determines action
- **Message Display:** "Computer Cashed In!" for 1.2 seconds

**AI Timing (Hot Dice Mode):**
- Delay before considering Cash In: 0 seconds (immediate check)
- If Cash In: Display message for 1.2 seconds, then execute
- If not Cash In: 
  - Delay before roll: 0.8 seconds
  - Display rolled die: immediate  
  - Delay before placement: 1.2 seconds
- Total AI turn duration: 2.0+ seconds

**Functional Requirements:**
- FR-AI-001.1: AI shall only activate when playerNumber == 1
- FR-AI-001.2: Classic Mode AI shall use strategic scoring algorithm
- FR-AI-001.3: Hot Dice AI shall use random placement algorithm
- FR-AI-001.4: AI shall introduce delays for human readability
- FR-AI-001.5: AI shall follow same rules as human players
- FR-AI-001.6: AI actions shall be visually identical to human actions
- FR-AI-001.7: AI shall have 30% Cash In probability in Hot Dice
- FR-AI-001.8: AI shall not cheat or have hidden information

**Known Limitations:**
- Hot Dice AI does not evaluate strategic placement
- AI does not consider long-term board building
- AI does not predict opponent responses
- Random placement may result in suboptimal play
- AI difficulty is not adjustable in Phase 1

---

## 6. Game Interface, Screens, and Menus <a name="section6"></a>

### 6.1 Screen Navigation Overview

**Navigation Flow Diagram:**

```
Application Launch
       ↓
[Main Menu Screen]
   ↓         ↓
  Hot      Classic
  Dice      Mode
   ↓         ↓
   └─────┬────┘
         ↓
[Options Menu Screen]
   ↓         ↓
  One      Two
 Player   Player
   ↓         ↓
   └─────┬────┘
         ↓
[Game Screen - Hot Dice OR Classic]
         ↓
      (Game Over
      Condition Met)
         ↓
[Game Over Screen]
   ↓         ↓
  Play    Return to
  Again   Main Menu
   ↓         ↓
   └─────────┘
```

**Scene File Structure:**

| Screen | Scene File | Script File | Purpose |
|--------|-----------|-------------|---------|
| Main Menu | main_menu.tscn | main_menu.gd | Game mode selection |
| Options Menu | options_menu.tscn | options_menu.gd | Player count selection |
| Classic Game | classic.tscn | classic.gd | Classic mode gameplay |
| Hot Dice Game | game.tscn | game.gd | Hot Dice mode gameplay |
| Game Over | game_over.tscn | game_over.gd | Results and replay |

### 6.2 Main Menu Screen

<a name="fig_mainmenu"></a>

**Purpose:** Initial screen where player selects game mode

**Visual Layout:**
```
┌────────────────────────────────────────────────┐
│                                                 │
│                                                 │
│              High Rollers                       │
│                (48pt font)                      │
│                                                 │
│                                                 │
│        ┌──────────────────────┐                │
│        │                      │                │
│        │      Hot Dice        │                │
│        │     (24pt font)      │                │
│        │                      │                │
│        └──────────────────────┘                │
│                                                 │
│        ┌──────────────────────┐                │
│        │                      │                │
│        │      Classic         │                │
│        │     (24pt font)      │                │
│        │                      │                │
│        └──────────────────────┘                │
│                                                 │
│                                                 │
└────────────────────────────────────────────────┘
```

**UI Elements:**

| Element | Type | Text | Font Size | Behavior |
|---------|------|------|-----------|----------|
| Title | Label | "High Rollers" | 48pt | Static display |
| Hot Dice Button | Button | "Hot Dice" | 24pt | Click → Set gameMode="game" → Options Menu |
| Classic Button | Button | "Classic" | 24pt | Click → Set gameMode="classic" → Options Menu |

**Color Scheme:**
- Background: Dark gray (RGB: 40, 43, 48)
- Text: White
- Buttons: Godot default theme

**Element Positioning:**
- Title: Centered horizontally, upper third of screen
- Buttons: Centered horizontally, vertically stacked with 20px separation
- Button size: Automatic (based on text content)

**Functional Requirements:**
- FR-UI-001.1: Main menu shall be first screen shown after launch
- FR-UI-001.2: Clicking "Hot Dice" shall set GameManager.gameMode = "game"
- FR-UI-001.3: Clicking "Classic" shall set GameManager.gameMode = "classic"
- FR-UI-001.4: Both buttons shall transition to Options Menu screen
- FR-UI-001.5: No default selection (player must explicitly choose)
- FR-UI-001.6: No back or exit button on main menu
- FR-UI-001.7: Screen shall load within 2 seconds of launch

**State Changes:**
```gdscript
// Hot Dice button pressed:
func _on_base_game_button_pressed():
    GameManager.gameMode = "game"
    SceneManager.change_scene("res://scenes/options_menu.tscn")

// Classic button pressed:
func _on_classic_button_pressed():
    GameManager.gameMode = "classic"
    SceneManager.change_scene("res://scenes/options_menu.tscn")
```

### 6.3 Options Menu Screen

<a name="fig_optionsmenu"></a>

**Purpose:** Select number of human players (1 vs AI or 2 human)

**Visual Layout:**
```
┌────────────────────────────────────────────────┐
│                                                 │
│                                                 │
│            Options Menu                         │
│              (48pt font)                        │
│                                                 │
│                                                 │
│        ┌──────────────────────┐                │
│        │                      │                │
│        │    One Player        │                │
│        │     (24pt font)      │                │
│        │                      │                │
│        └──────────────────────┘                │
│                                                 │
│        ┌──────────────────────┐                │
│        │                      │                │
│        │    Two Player        │                │
│        │     (24pt font)      │                │
│        │                      │                │
│        └──────────────────────┘                │
│                                                 │
│                                                 │
└────────────────────────────────────────────────┘
```

**UI Elements:**

| Element | Type | Text | Font Size | Behavior |
|---------|------|------|-----------|----------|
| Title | Label | "Options Menu" | 48pt | Static display |
| One Player Button | Button | "One Player" | 24pt | Set playerNumber=1 → Load game |
| Two Player Button | Button | "Two Player" | 24pt | Set playerNumber=2 → Load game |

**Functional Requirements:**
- FR-UI-002.1: Options menu shall appear after game mode selection
- FR-UI-002.2: "One Player" shall set GameManager.playerNumber = 1 (AI opponent)
- FR-UI-002.3: "Two Player" shall set GameManager.playerNumber = 2 (both human)
- FR-UI-002.4: Button click shall load appropriate game scene based on gameMode
- FR-UI-002.5: If gameMode="game": Load game.tscn (Hot Dice)
- FR-UI-002.6: If gameMode="classic": Load classic.tscn (Classic)

**State Changes:**
```gdscript
// One Player button:
func _on_player_one_button_pressed():
    GameManager.playerNumber = 1
    if GameManager.gameMode == "classic":
        SceneManager.change_scene("res://scenes/classic.tscn")
    elif GameManager.gameMode == "game":
        SceneManager.change_scene("res://scenes/game.tscn")

// Two Player button:
func _on_player_two_button_pressed():
    GameManager.playerNumber = 2
    if GameManager.gameMode == "classic":
        SceneManager.change_scene("res://scenes/classic.tscn")
    elif GameManager.gameMode == "game":
        SceneManager.change_scene("res://scenes/game.tscn")
```

### 6.4 Classic Mode Game Screen

<a name="fig_classic"></a>

**Purpose:** Main gameplay screen for Classic Mode

**Visual Layout (1600×900 viewport):**
```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│          Player 1's Turn: Roll the dice! (23pt)                 │
│                                                                  │
│  P2 Score: 27                              P1 Score: 45         │
│    (23pt)                                      (23pt)           │
│                                                                  │
│  ┌──────────┐         ┌─────┐         ┌──────────┐            │
│  │          │         │     │         │          │            │
│  │  P2 Grid │         │  4  │         │  P1 Grid │            │
│  │ (Rotated │         │Die  │         │ (Rotated │            │
│  │  90°CCW) │         │Roll │         │  90°CCW) │            │
│  │          │         │     │         │          │            │
│  │  3×3     │         └─────┘         │  3×3     │            │
│  │          │                         │          │            │
│  │ [Col 1]  │                         │ [Col 1]  │            │
│  │ [Col 2]  │      [Roll Button]      │ [Col 2]  │            │
│  │ [Col 3]  │        (28pt)           │ [Col 3]  │            │
│  │          │                         │          │            │
│  └──────────┘                         └──────────┘            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**UI Elements Specifications:**

**Score Labels:**
- Position: Top corners
- Format: "P1 Score: XXX" / "P2 Score: XXX"
- Font: 23pt
- Color: White
- Update: Every frame after state change

**Turn Indicator:**
- Position: Top center
- Font: 23pt
- Color: White
- States:
  - "Player 1's Turn: Roll the dice!"
  - "Player 1 Rolled: [value]"
  - "Player 2's Turn: Roll the dice!"
  - "Player 2 Rolled: [value]"

**Player Grids:**
- Size: 3×3 dice slots
- Rotation: 90° counterclockwise
- Position: Left (P2) and Right (P1) sides
- Die size: 100×100 pixels
- Spacing: 4px horizontal, 5px vertical

**Column Buttons:**
- Count: 3 per player (behind each grid)
- Size: ~100×200 pixels (tall rectangles)
- Text: Whitespace/newlines for height
- States: Enabled (player's turn) / Disabled (opponent's turn or full)
- Z-index: -1 (behind grid)

**Rolled Die Display:**
- Position: Center of screen
- Size: 170×170 pixels (scaled 1.7×)
- Visibility: Only when die rolled
- Shows value 1-6 using SVG texture

**Roll Button:**
- Position: Below die display area
- Text: "Roll" (28pt)
- Scale: 1.4×
- Visibility: Only during current player's pre-roll phase
- States: Enabled→Disabled after click

**Functional Requirements:**
- FR-UI-003.1: Grids shall display all dice placed by both players
- FR-UI-003.2: Column buttons shall be clickable only by active player
- FR-UI-003.3: Roll button shall disable after single use per turn
- FR-UI-003.4: Scores shall update within 100ms of placement
- FR-UI-003.5: Turn indicator shall accurately reflect game state
- FR-UI-003.6: Die textures shall load from assets/dice_X.svg files
- FR-UI-003.7: Grid rotation shall be purely visual (logic uses standard orientation)

**Board Visual Representation:**

Player 1 Grid (right side, rotated 90° CCW):
```
Physical Layout (rotated):     Logical Layout (in code):
┌───┬───┬───┐                  Column 0: [row0, row1, row2]
│ 6 │ 5 │ 4 │ ← Column 3       Column 1: [row0, row1, row2]
├───┼───┼───┤                  Column 2: [row0, row1, row2]
│ 6 │ 5 │ 0 │ ← Column 2
├───┼───┼───┤
│ 3 │ 0 │ 0 │ ← Column 1
└───┴───┴───┘
```

### 6.5 Hot Dice Mode Game Screen

<a name="fig_hotdice"></a>

**Purpose:** Main gameplay screen for Hot Dice Mode

**Visual Layout (1600×900 viewport):**
```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│          Player 1's Turn: Roll the dice! (23pt)                 │
│                                                                 │
│  P2 Score: 27                              P1 Score: 45         │
│    (23pt)                                      (23pt)           │
│                                                                 |
│  ┌───────────┐                          ┌───────────┐           │
│  │ ┌───┬───┬───┐     ┌─────┐          │ ┌───┬───┬───┐           │
│  │ ├───┼───┼───┤     │     │          │ ├───┼───┼───┤           │
│  │ └───┴───┴───┘     │  4  │          │ └───┴───┴───┘           │
│  │   P2 Grid         │ Die │          │   P1 Grid               │
│  │   3×3 Tiles       │Roll │          │   3×3 Tiles             │
│  │   (Standard       └─────┘          │   (Standard             │ 
│  │   orientation)                     │   orientation)          │
│  └───────────┘                         └───────────┘            │
│                                                                 │
│  HP: ████████░░ 80/100                HP: ██████████100/100     │
│  [Roll] [Cash In]                     [Roll] [Cash In]          │
│   (28pt)  (28pt)                       (28pt)  (28pt)           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**UI Elements Specifications:**

**Player Grids:**
- Size: 3×3 clickable tiles
- Rotation: None (standard orientation)
- Position: Left (P2) and Right (P1) sides
- Each tile: 153×154 pixels
- Direct click placement (not column-based)

**Dice Tiles:**
- Type: TextureRect with Area2D collision
- States: Empty (transparent) / Occupied (shows die texture)
- Mouse detection: Area2D signals (mouse_entered, mouse_exited)
- Click handling: Input event on Area2D
- Die texture scale: 1.2×

**Health Bars:**
- Type: ProgressBar
- Position: Bottom of screen below each grid
- Size: 150×27 pixels
- Range: 0-100
- Display format: Visual bar + numeric (optional)
- Colors:
  - Default: White fill
  - Damage: Red flash (0.2s)
  - Heal: Green flash (0.2s)

**Roll Button:**
- Position: Near bottom, aligned with player side
- Text: "Roll" (28pt)
- Visibility: Only current player's button shown
- Behavior: Click → Generate die → Enable tiles

**Cash In Button:**
- Position: Next to Roll button
- Text: "Cash In" (28pt)
- Visibility: Only current player's button shown
- Enabled: Only if dice on board AND no roll pending
- Behavior: Click → Calculate damage → Clear board → Switch turn

**Rolled Die Display:**
- Position: Center between grids
- Size: 100×100 pixels (0.5× scale)
- Spawn position: Marker2D at (776, 251) world coordinates
- Visibility: From roll until placement
- Texture: Loaded from assets/dice_X.svg

**Functional Requirements:**
- FR-UI-004.1: Each tile shall be individually clickable
- FR-UI-004.2: Tiles shall only respond to clicks when enabled
- FR-UI-004.3: Health bars shall update immediately on HP change
- FR-UI-004.4: Damage/heal animations shall play for 0.4 seconds
- FR-UI-004.5: Cash In button shall disable when board empty
- FR-UI-004.6: Only active player's buttons shall be visible
- FR-UI-004.7: Grid shall not rotate (standard 0° orientation)

**Tile Grid Layout:**

Logical and Visual Layout (same):
```
Grid Indices:
  Col: 0   1   2
Row 0: [0,0][0,1][0,2]
Row 1: [1,0][1,1][1,2]
Row 2: [2,0][2,1][2,2]

Destruction matches by row:
- Placing at Row 0 affects opponent Row 0
- Placing at Row 1 affects opponent Row 1
- Placing at Row 2 affects opponent Row 2
```

### 6.6 Game Over Screen

<a name="fig_gameover"></a>

**Purpose:** Display game results and provide replay options

**Visual Layout:**
```
┌─────────────────────────────────────────────────┐
│         [Semi-transparent dark overlay]          │
│                                                  │
│                                                  │
│                                                  │
│              Player 1 Wins!                      │
│                    OR                            │
│              Player 2 Wins!                      │
│                    OR                            │
│               Its a draw!                        │
│             (Result text - size varies)          │
│                                                  │
│                                                  │
│        ┌─────────────────────┐                  │
│        │                     │                  │
│        │    Play Again       │                  │
│        │     (23pt)          │                  │
│        │                     │                  │
│        └─────────────────────┘                  │
│                                                  │
│        ┌──────────────────────────┐             │
│        │                          │             │
│        │  Return to Main Menu     │             │
│        │       (23pt)             │             │
│        │                          │             │
│        └──────────────────────────┘             │
│                                                  │
│                                                  │
└─────────────────────────────────────────────────┘
```

**UI Elements:**

| Element | Type | Content | Behavior |
|---------|------|---------|----------|
| Background Overlay | ColorRect | Semi-transparent black (alpha 0.25) | Static |
| Result Text | Label | GameManager.winner_text | Dynamic content |
| Play Again Button | Button | "Play Again" (23pt) | Restart same mode |
| Main Menu Button | Button | "Return to Main Menu" (23pt) | Back to start |

**Result Text Values:**
- "Player 1 Wins!" - Player 1 victory
- "Player 2 Wins!" - Player 2 victory
- "Its a draw!" - Classic Mode tie (note: intentional grammar)

**Functional Requirements:**
- FR-UI-005.1: Game Over screen shall load immediately on win condition
- FR-UI-005.2: Result text shall display GameManager.winner_text value
- FR-UI-005.3: "Play Again" shall reload same game mode with same player count
- FR-UI-005.4: "Return to Main Menu" shall load main_menu.tscn
- FR-UI-005.5: GameManager state shall persist for Play Again
- FR-UI-005.6: Background shall overlay previous game screen
- FR-UI-005.7: Screen shall be non-dismissible (must click button)

**Button Behaviors:**
```gdscript
func _on_play_again_button_pressed():
    if GameManager.gameMode == "game":
        SceneManager.change_scene("res://scenes/game.tscn")
    elif GameManager.gameMode == "classic":
        SceneManager.change_scene("res://scenes/classic.tscn")

func _on_main_menu_button_pressed():
    SceneManager.change_scene("res://scenes/main_menu.tscn")
```

### 6.7 UI Color Scheme and Typography

**Color Palette:**

| Element Type | Color | RGB Values | Hex Code |
|--------------|-------|------------|----------|
| Background | Dark Gray | (40, 43, 48) | #282B30 |
| Primary Text | White | (255, 255, 255) | #FFFFFF |
| Button Default | Godot Theme | N/A | System |
| Health Bar Default | White | (255, 255, 255) | #FFFFFF |
| Health Bar Damage | Red | (255, 0, 0) | #FF0000 |
| Health Bar Heal | Green | (0, 255, 0) | #00FF00 |

**Typography:**

| Text Type | Font Size | Usage |
|-----------|-----------|-------|
| Title | 48pt | Screen headings |
| Button | 24pt | Main menu buttons |
| Button (scaled) | 28pt | In-game actions |
| Labels | 23pt | Scores, turn indicators |

**Font:** Godot default system font (all text)


## 7. Feature Prioritization <a name="section7"></a>

### 7.1 Core Features (Must-Have - Phase 1)

These features are **essential** for minimum viable product and must be fully functional for project success:

**Game Modes:**
- Classic Mode with column-based placement
- Hot Dice Mode with health and Cash In system
- Mode selection from main menu
- Player count selection (1 or 2 players)

**Core Mechanics:**
- Six-sided dice rolling (1-6 random generation)
- 3×3 grid placement system
- Dice destruction mechanic (matching values in rows)
- Multiplier scoring formula (count × value × count)
- Turn-based gameplay alternation
- Win condition detection and game over

**Classic Mode Specific:**
- Column button placement interface
- Bottom-to-top fill order within columns
- Board-fill end condition
- Highest score wins determination

**Hot Dice Mode Specific:**
- 100 HP starting health for both players
- Health bar visual display
- Cash In damage calculation and application
- Dice-1 healing effect on destruction
- HP-based win condition (0 HP = loss)
- Damage and heal animations

**AI Opponent:**
- Single-player mode functional
- Strategic AI for Classic Mode (scoring-based decisions)
- Functional AI for Hot Dice Mode (random placement)
- AI Cash In behavior (probabilistic)

**User Interface:**
- Main Menu screen
- Options Menu (player selection)
- Game Over screen with results
- Score displays updating in real-time
- Turn indicator labels
- Play again functionality

**Success Criteria:**
- All core features implemented and bug-free
- Both game modes playable start-to-finish
- AI provides reasonable challenge in Classic Mode
- Win conditions correctly detected
- Smooth transitions between screens
- No game-breaking bugs or crashes

### 7.2 Secondary Features (Should-Have - Phase 2-3)

These features enhance gameplay and user experience but aren't critical for initial release:

**Enhanced AI:**
- Strategic AI for Hot Dice Mode (evaluates placement value vs random)
- Adjustable difficulty levels (Easy/Medium/Hard)
- AI personality settings (aggressive vs defensive Cash In)
- Improved decision-making algorithms

**Visual Enhancements:**
- Dice roll animation (spinning/tumbling effect)
- Placement animations (dice sliding into position)
- Enhanced destruction effects (particles, fade-out)
- Smooth health bar drain animations
- Victory celebration animations

**Audio:**
- Dice roll sound effects
- Placement confirmation sounds
- Destruction sound effects
- Cash In impact sound
- Background music (menu and gameplay)
- UI click sounds

**Gameplay Features:**
- Undo last move functionality (Classic Mode only)
- Move timer (optional pressure mechanic)
- Statistics tracking (wins, losses, highest scores)
- Match history review
- Best-of-3 or best-of-5 match modes

**UI Improvements:**
- How To Play tutorial screen with examples
- In-game help overlay (rules reminder)
- Settings menu (volume, resolution, fullscreen)
- Pause functionality with menu
- Animated transitions between screens
- Visual indicators for valid placement zones

**Mobile Optimization:**
- Touch-optimized button sizes (minimum 100×100px)
- Haptic feedback on placement
- Portrait orientation support
- Swipe gesture controls (future consideration)
- Battery-efficient rendering mode

### 7.3 Stretch Goals (Nice-to-Have - Future Versions)

These features represent long-term enhancements beyond initial project scope:

**Online Multiplayer:**
- Network play over internet
- Matchmaking system
- Friend lists and invites
- Ranked/unranked modes
- Spectator mode

**Progression System:**
- Player profiles with persistent data
- Experience points and leveling
- Unlockable content (dice skins, board themes)
- Achievement system
- Daily/weekly challenges

**Advanced Gameplay:**
- Tournament bracket system
- Power-ups and special abilities
- Different board sizes (4×4, 5×5 variants)
- Alternative scoring rules (custom modes)
- Dice with special values (wildcards, multipliers)

**Monetization (if commercial):**
- Coin economy for unlocks
- Cosmetic purchases
- Premium features
- Ad-supported free version

**Platform Expansion:**
- iOS App Store release
- Google Play Store release
- Steam release (PC)
- Nintendo Switch port
- Web browser version (HTML5 export)

**Accessibility:**
- Color-blind friendly mode
- Screen reader support
- Remappable controls
- Font size options
- High contrast mode

**3D Graphics:**
- Upgrade from 2D to 3D rendering
- 3D dice models with physics simulation
- Dynamic camera angles
- Enhanced lighting and shadows
- Particle effects systems

## 8. Non-Functional Requirements <a name="section8"></a>

### 8.1 Performance Requirements

**Response Time Specifications:**

| Action | Maximum Response Time | Target Response Time |
|--------|----------------------|---------------------|
| Application Launch | 3 seconds | 2 seconds |
| Screen Transition | 500ms | 300ms |
| Dice Roll Generation | 50ms | 20ms |
| Dice Placement | 200ms | 100ms |
| Score Calculation | 50ms | 20ms |
| AI Turn Complete | 3 seconds | 2 seconds |
| Health Bar Update | 100ms | 50ms |

**Frame Rate Requirements:**
- Target: 60 FPS during all gameplay
- Minimum Acceptable: 30 FPS
- Critical Sections: Animations, dice rolling, placement
- Performance Testing: Must maintain 60 FPS on minimum spec hardware

**Memory Usage:**
- Maximum RAM: 200MB during active gameplay
- Target RAM: 150MB average
- Memory Leaks: Zero tolerance - no leaks over 1-hour session
- Texture Memory: < 50MB for all assets
- Scene Memory: < 20MB per loaded scene

**Load Times:**
- Scene Load: < 500ms for all transitions
- Asset Load: All dice textures cached on startup
- First Launch: < 5 seconds from icon click to main menu

**Throughput Requirements:**
- User Input Processing: < 16ms (within single frame at 60 FPS)
- State Update: < 10ms per frame
- Render Pipeline: < 16ms per frame
- Total Frame Budget: 16.67ms (60 FPS)

### 8.2 Reliability Requirements

**Crash Prevention:**
- Zero crashes during normal gameplay
- Graceful handling of all error conditions
- No null reference exceptions
- Proper bounds checking on all array accesses
- Input validation on all user actions

**Data Integrity:**
- Game state consistency guaranteed at all times
- Score calculations must be deterministic and repeatable
- No desync between visual display and underlying data
- Health values cannot exceed bounds (0-100)
- Grid state must always match displayed dice

**Error Handling Standards:**
```gdscript
// Array access - always validate bounds
if index >= 0 and index < array.size():
    value = array[index]
else:
    push_error("Index out of bounds: %d" % index)
    return default_value

// Null checks before accessing objects
if dice_object != null:
    dice_object.destroy()
else:
    push_warning("Attempted to destroy null dice")

// Division - check for zero
if divisor != 0:
    result = dividend / divisor
else:
    push_error("Division by zero prevented")
    result = 0
```

**Recovery Procedures:**
- Invalid state detected: Reset to last known good state
- Null reference: Use safe defaults, log warning
- Out of bounds: Clamp to valid range, log error
- Unexpected value: Sanitize input, continue execution

### 8.3 Usability Requirements

**Learnability:**
- New players understand basic mechanics within 2 game turns
- Rules comprehensible from UI alone (minimal external documentation needed)
- Visual feedback confirms all actions
- Errors silently handled (clicking occupied space has no confusing effect)

**Efficiency:**
- Experienced players complete turn in < 10 seconds
- No unnecessary clicks or actions required
- Direct manipulation (click where you want to place)
- Minimal navigation depth (max 3 screens to start game)

**Memorability:**
- Returning players remember how to play after 1 week absence
- Consistent button placement across screens
- Predictable outcomes for all actions
- Standard conventions followed (ESC for back/cancel)

**Error Prevention:**
- Invalid actions silently ignored (don't show error messages)
- Buttons disabled when action unavailable
- Visual feedback shows valid placement zones
- Confirmation not required (all actions reversible via game flow)

**Satisfaction:**
- Game feels responsive (< 100ms feedback for all actions)
- Animations smooth and non-jarring
- Victory/defeat clearly communicated
- Fair gameplay (no hidden mechanics or surprise rules)

### 8.4 Maintainability Requirements

**Code Organization:**
- Modular architecture: Each game mode in separate scene
- Singleton pattern for global state (GameManager, SceneManager)
- Clear separation: UI scripts, game logic scripts, data structures
- Maximum function length: 50 lines
- Maximum file length: 500 lines

**Documentation Standards:**
- All public functions documented with purpose and parameters
- Complex algorithms explained with comments
- Magic numbers replaced with named constants
- Code follows GDScript style guide exactly

**Modifiability:**
Critical values externalized for easy tuning:

```gdscript
// Easy to modify game balance
const MAX_HEALTH: int = 100
const GRID_SIZE: int = 3
const DICE_MIN: int = 1
const DICE_MAX: int = 6
const AI_CASH_IN_PROBABILITY: float = 0.3

// Scoring formula in single function
func calculate_row_score(row: Array) -> int:
    # Centralized scoring logic
    # Modify once, affects everywhere
```

**Testability:**
- Pure functions for calculations (no side effects)
- Game state accessible for inspection
- Deterministic behavior (same input = same output)
- Debug functions for state manipulation
- Print functions for state inspection

### 8.5 Portability Requirements

**Cross-Platform Compatibility:**
- Single codebase for all platforms
- Platform-specific code isolated in wrapper functions
- File paths use Godot res:// system (platform-agnostic)
- Input handling supports both mouse and touch
- No platform-specific APIs or features

**Resolution Scaling:**
- Base viewport: 1600×900
- Stretch mode: canvas_items (maintains aspect, scales content)
- Supports resolutions: 1280×720 up to 1920×1080
- UI elements scale proportionally
- Text remains readable at all supported resolutions

**Export Targets:**

| Platform | Status | Notes |
|----------|--------|-------|
| Windows 64-bit | Supported | Primary development platform |
| macOS | Supported | Intel and Apple Silicon |
| Linux | Supported | Ubuntu 20.04+ tested |
| Android | Planned | Phase 2-3 |
| iOS | Planned | Phase 2-3 |
| HTML5 | Possible | Stretch goal |

### 8.6 Security Requirements

**Data Privacy:**
- No personal data collected
- No network communication (local-only gameplay)
- No user accounts or authentication
- No data stored on disk (except Godot config)
- Session data cleared on application exit

**Input Validation:**
- All user inputs validated before processing
- Click coordinates validated against valid ranges
- Array indices bounds-checked
- Numeric values clamped to valid ranges

**Cheating Prevention:**
- No console/debug access in release builds
- No exposed variables in production
- Dice generation uses cryptographically secure random (future)
- Score calculations server-side (if online multiplayer added)

---

## 9. Use Cases and Scenarios <a name="section9"></a>

### Use Case 1: Starting a Classic Game (vs AI)

**Primary Actor:** Player  
**Goal:** Begin new Classic Mode game against computer opponent  
**Preconditions:** Application launched, at main menu

**Main Success Scenario:**

1. Player sees main menu with "High Rollers" title
2. Player clicks "Classic" button
3. GameManager.gameMode set to "classic"
4. Screen transitions to Options Menu
5. Player clicks "One Player" button
6. GameManager.playerNumber set to 1
7. Classic game scene loads (classic.tscn)
8. Game initializes with both grids empty [[0,0,0],[0,0,0],[0,0,0]]
9. Random first turn determined: `player_turn = randi() % 2 + 1`
10. Assume Player 1 goes first (50% chance)
11. Turn indicator shows: "Player 1's Turn: Roll the dice!"
12. Player 1's Roll button becomes visible
13. Player ready to roll

**Postconditions:**
- Game loaded and initialized
- Player 1 can interact with Roll button
- AI ready to take turn when appropriate
- Scores displayed as 0-0

**Estimated Duration:** 5 seconds from launch to ready

### Use Case 2: Completing a Full Turn (Classic Mode)

**Primary Actor:** Current Player  
**Goal:** Roll die, place it strategically, end turn  
**Preconditions:** Player's turn active, Roll button visible

**Main Success Scenario:**

1. Player observes current board state:
   - Own grid: [[6,0,0], [5,5,0], [0,0,0]]
   - Opponent grid: [[4,4,2], [3,0,0], [6,0,0]]
   - Own score: 31 points
   - Opponent score: 29 points

2. Player clicks "Roll" button
3. System generates random: `randi() % 6 + 1` → Result: 5
4. Die appears in center showing value 5
5. Turn indicator updates: "Player 1 Rolled: 5"
6. Roll button disables
7. Player's column buttons become active

8. Player evaluates options:
   - Column 0: Full (6,?,?) - Cannot place
   - Column 1: Has matching 5 - Would create [5,5,5] = 45 points!
   - Column 2: Empty - Just 5 points

9. Player clicks Column 1 button
10. System places 5 in column 1, index 2: [5,5,5]
11. System checks opponent's Row 2 for value 5: None found
12. No destruction occurs

13. System recalculates scores:
    - Player: Row 0: 6, Row 1: 45, Row 2: 0 = 51 total
    - Score label updates: "P1 Score: 51"

14. Turn ends, switches to opponent
15. Turn indicator: "Player 2's Turn: Roll the dice!"
16. Player 2's (AI) roll button appears

**Postconditions:**
- Player's grid updated with new die
- Score increased from 31 to 51
- Turn switched to opponent
- System ready for next turn

**Estimated Duration:** 5-10 seconds

### Use Case 3: AI Computer Turn (Classic Mode)

**Primary Actor:** Computer AI  
**Goal:** Execute strategic turn without human input  
**Preconditions:** AI's turn active (player_turn = 2, playerNumber = 1)

**Main Success Scenario:**

1. System detects AI turn: player_turn = 2 and playerNumber = 1
2. Player 1's buttons all disable
3. AI waits 0.5 seconds (thinking delay)

4. AI rolls die: `randi() % 6 + 1` → Result: 4
5. Die displays in center showing 4
6. Turn indicator: "Player 2 Rolled: 4"
7. AI waits 0.5 seconds (decision delay)

8. AI evaluates columns using scoring algorithm:
   - AI Column 0: [6, 3, 2] (full) → Score: -100
   - AI Column 1: [0, 0, 0] (empty) → Score: 3 (three empties)
   - AI Column 2: [4, 0, 0] (has 4) → Score: 1 (empty) + 10 (match) = 11

   - Opponent Row 0: [6, 5, 0] (no 4)
   - Opponent Row 1: [5, 5, 5] (no 4)
   - Opponent Row 2: [4, 0, 0] (has 4!) → +4 destroy bonus

   Final scores:
   - Column 0: -100
   - Column 1: 3
   - Column 2: 11 + 4 = 15 (BEST)

9. AI selects Column 2 (highest score: 15)
10. System places 4 in AI Column 2: [4, 4, 0]
11. System checks Opponent (Player 1) Row 2 for value 4: Found at index 0!
12. System destroys Player 1's die (value 4) in Row 2, Column 0
13. Player 1's row updates: [4,0,0] → [0,0,0]

14. Scores recalculate:
    - AI: Row 0: full calculation
    - AI: Row 2: 2×4×2 = 16 points (two 4s)
    - Player 1: Row 2 now empty (lost points)

15. Turn switches to Player 1
16. Turn indicator: "Player 1's Turn: Roll the dice!"
17. Player 1's Roll button appears

**Postconditions:**
- AI placed die strategically (matched own die, destroyed opponent)
- Player 1 lost die and points
- Turn returned to human player
- Game continues

**Estimated Duration:** ~1.5 seconds total

### Use Case 4: Winning Classic Mode Game

**Primary Actor:** Player  
**Goal:** Fill grid completely and win by highest score  
**Preconditions:** Game in progress, Player 1 has 8/9 spaces filled

**Main Success Scenario:**

1. Turn 15 of game
2. Current state:
   - Player 1 grid: 8/9 spaces occupied (one empty in Column 2)
   - Player 2 grid: 7/9 spaces occupied
   - Player 1 score: 118
   - Player 2 score: 97

3. Player 1's turn begins
4. Player rolls: Result = 6
5. Player clicks Column 2 (only column with space)
6. System places 6 in final space
7. Player 1 grid now: [[6,5,4], [6,5,3], [6,5,2]]

8. System detects grid full: All values ≠ 0
9. Win condition triggered

10. System calculates final scores:
    - Player 1:
      - Row 0: [6,5,4] = 6+5+4 = 15
      - Row 1: [6,5,3] = 6+5+3 = 14
      - Row 2: [6,5,2] = 6+5+2 = 13
      - Total: 42 points

    Wait, let me recalculate with the multiplier formula...
    - Row 0: [6,5,4] = (1×6×1)+(1×5×1)+(1×4×1) = 15
    - Row 1: [6,5,3] = 6+5+3 = 14  
    - Row 2: [6,5,2] = 6+5+2 = 13
    - Hmm, no multipliers here. Let me use a better example...

Actually, let me revise with multipliers:
    - Player 1 Final Grid: [[6,6,3], [5,5,5], [4,4,2]]
    - Row 0: (2×6×2) + (1×3×1) = 24 + 3 = 27
    - Row 1: (3×5×3) = 45
    - Row 2: (2×4×2) + (1×2×1) = 16 + 2 = 18
    - Total: 90 points

    - Player 2 Final Grid: [[6,3,2], [5,5,4], [4,3,2]]
    - Row 0: 6+3+2 = 11
    - Row 1: (2×5×2) + 4 = 24
    - Row 2: 4+3+2 = 9
    - Total: 44 points

11. Winner determination: 90 > 44
12. System sets GameManager.winner_text = "Player 1 Wins!"
13. System sets game_over = true
14. Scene transitions to game_over.tscn
15. Game Over screen displays: "Player 1 Wins!"
16. Buttons shown: "Play Again" and "Return to Main Menu"

**Postconditions:**
- Game ended correctly
- Correct winner determined by score
- Player can choose to play again or return to menu
- GameManager retains gameMode and playerNumber for replay

**Estimated Duration:** Full game 5-10 minutes

### Use Case 5: Using Cash In (Hot Dice Mode)

**Primary Actor:** Player  
**Goal:** Convert board score to damage and clear board  
**Preconditions:** Hot Dice mode active, player has dice on board

**Main Success Scenario:**

1. Game state:
   - Player 1 HP: 67/100
   - Player 2 HP: 55/100
   - Player 1 Board: [[6,6,6], [5,5,0], [3,0,0]]
   - Player 1 Score: 54 + 20 + 3 = 77 points
   - Player 1's turn active

2. Player evaluates situation:
   - Current score of 77 is substantial
   - Opponent at 55 HP
   - Can deal 77 damage (would reduce opponent to 0 HP!)
   - Decision: Cash In for the win

3. Player clicks "Cash In" button

4. System validates:
   - ✓ Player 1's turn
   - ✓ current_dice == null (no pending placement)
   - ✓ Board has dice (not empty)
   - Validation passes

5. System calculates score:
   - Row 0: 3×6×3 = 54
   - Row 1: 2×5×2 = 20
   - Row 2: 1×3×1 = 3
   - Total: 77 points

6. System applies damage:
   - Player 2 HP: 55 - 77 = -22
   - Clamp to minimum: max(0, -22) = 0
   - Player 2 HP now: 0/100

7. Animation plays:
   - Player 2 health bar flashes red (0.2s)
   - Health bar drains to empty
   - Flash back to white (0.2s)

8. System clears Player 1 board:
   - All grid positions set to 0
   - Die objects destroyed with animation
   - Grid now: [[0,0,0], [0,0,0], [0,0,0]]

9. System checks win condition:
   - Player 2 HP = 0
   - Win condition met!

10. System sets GameManager.winner_text = "Player 1 Wins!"
11. System sets game_over = true
12. Scene transitions to game_over.tscn
13. Game Over screen shows: "Player 1 Wins!"

**Postconditions:**
- Player 2 defeated (0 HP)
- Player 1 declared winner
- Game ended
- Can replay or return to menu

**Alternative Scenario A: Opponent Survives**

At step 6, if damage insufficient:
- Player 2 HP: 55 - 30 = 25 (survives)
- Animation plays, board clears
- Turn switches to Player 2
- Game continues

**Estimated Action Duration:** 2-3 seconds from click to turn switch

### Use Case 6: Dice-1 Healing Effect

**Primary Actor:** System (automatic)  
**Goal:** Heal player when their dice showing 1 is destroyed  
**Preconditions:** Player has die with value 1, opponent places matching 1

**Main Success Scenario:**

1. Game state:
   - Player 1 HP: 78/100
   - Player 1 Board Row 1: [1, 5, 0]
   - Player 2's turn, rolls 1

2. Player 2 clicks tile in their Row 1
3. System places Player 2's die (value 1) in their Row 1

4. Destruction mechanic triggers:
   - Check Player 1 Row 1 for value 1
   - Found: Player 1 has 1 in Row 1, Column 0
   - System destroys Player 1's die (value 1)

5. **Healing Effect Triggers:**
   - System detects destroyed die was value 1
   - Owner (Player 1) gains +1 HP
   - Player 1 HP: 78 + 1 = 79

6. Health bar animation:
   - Player 1 health bar flashes green (0.2s)
   - Health value increases visually
   - Flash back to white (0.2s)

7. Board updates:
   - Player 1 Row 1: [1, 5, 0] → [5, 0, 0] (1 removed, dice shift)
   - Player 2 Row 1: [1, ?, ?] (newly placed)

8. Scores recalculate
9. Turn switches to Player 1

**Postconditions:**
- Player 1 healed by 1 HP (78 → 79)
- Player 1's die removed from board
- Turn switched normally
- Game continues

**Edge Case: Already at Max HP**

If Player 1 HP = 100:
- Healing still triggers
- HP calculation: 100 + 1 = 101
- Clamped: max(100, min(101, 100)) = 100
- HP remains 100 (no overflow)
- Green flash still plays (visual feedback)

**Estimated Duration:** 0.5 seconds total

---

## 10. Glossary <a name="section10"></a>

**AI (Artificial Intelligence):**  
Computer-controlled opponent that makes automated decisions. In High Rollers, the AI uses scoring algorithms (Classic Mode) or random selection (Hot Dice Mode) to choose placements.

**Board / Grid:**  
The 3×3 playing area where each player places their dice. Each board has 9 spaces arranged in 3 rows and 3 columns.

**Cash In:**  
Hot Dice Mode action where player converts their accumulated board score into damage dealt to opponent's HP. Clears all dice from player's board after execution.

**Classic Mode:**  
Game mode where objective is highest score when either board fills completely. Uses column-based placement and scoring multipliers.

**Column:**  
Vertical division of the grid. Classic Mode has 3 columns that fill bottom-to-top.

**Destruction Mechanic:**  
Core game rule: When player places die, any opponent dice with matching value in same row are removed from opponent's board.

**Die / Dice:**  
Six-sided cube showing values 1-6. Players roll one die per turn and place it on their grid.

**GameManager:**  
Godot singleton (autoload) that stores persistent game state across scenes: gameMode, playerNumber, winner_text.

**GDScript:**  
Python-like scripting language used in Godot engine. Primary programming language for High Rollers.

**Godot:**  
Open-source game engine (version 4.5+) used to develop High Rollers. Provides scene system, rendering, input handling.

**Grid Index:**  
Numerical position identifier for grid spaces. Format: (column, row) or (x, y) with values 0-2 for each axis.

**Health Points (HP):**  
Hot Dice Mode resource representing player vitality. Starts at 100, decreases via Cash In damage, reaches 0 triggers loss.

**Hot Dice Mode:**  
Game mode with HP system where objective is reducing opponent to 0 HP. Features Cash In action and dice-1 healing.

**Local Multiplayer:**  
Two players sharing single device, taking turns. Contrast with online multiplayer (separate devices over network).

**Multiplier:**  
Scoring mechanic where matching dice in same row have value multiplied by quantity squared. Formula: count × value × count.

**Placement:**  
Action of putting rolled die onto player's grid. Classic Mode: column-based. Hot Dice Mode: direct tile selection.

**Row:**  
Horizontal division of grid. Both modes have 3 rows (indices 0-2). Destruction mechanic operates row-by-row.

**SceneManager:**  
Godot singleton that handles screen transitions using `change_scene()` function.

**Score:**  
Numerical value representing board strength. Calculated using multiplier formula on each row, then summed.

**Singleton:**  
Godot autoload script accessible from any scene. High Rollers uses GameManager and SceneManager singletons.

**Tile:**  
Individual clickable space within Hot Dice grid. Each tile can hold one die or be empty.

**Turn:**  
Single player's opportunity to roll die and place it. Turns alternate between players until game ends.
