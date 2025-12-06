
# CSCI 265 Team User Acceptance Test Plan

## Team name: THe High Rollers

## Project/product name: High Rollers

## Contact person and email

Seth William Doyle, seth.william.doyle@gmail.com

---

## General Overview

This document describes manual user acceptance testing for High Rollers, a two-mode dice game built in Godot 4.5. Testing verifies all requirements through human testers playing the game and checking that features work as specified.

**Testing Approach:** Manual gameplay testing - play the game and verify features work correctly  
**Primary Platform:** Windows 10/11 with limited macOS and Linux testing  
**Coverage:** Both game modes, all UI screens, game mechanics, AI behavior, win conditions  
**Tools:** Godot 4.5, exported builds, screen recording (OBS), GitHub Issues for bugs

---

## Known Issues

**Incomplete Elements:**
- No automated testing (all manual)
- Only 8 of 52 test cases have detailed descriptions
- No saved game states for quick setup
- Limited cross-platform testing (5 Windows, 1 Mac, 2 Linux users)
- AI testing requires multiple game observations due to randomness

**Future Work:**
- Complete all test case details
- Create automated regression tests
- Performance benchmarking tools

---

## Test Plan

### Testing Overview

**Purpose:** Verify High Rollers meets all requirements by playing the game and checking features  
**Scope:** Both game modes, all screens, mechanics, AI, win conditions  
**Team:** 5 members, each testing different areas  
**Duration:** 1 week (Dec 5-12), approximately 50 person-hours  
**Success:** 0 critical bugs, 90%+ pass rate

### Key Testing Challenges

**1. AI Randomness**
- Classic AI has random tie-breaking, Hot Dice AI uses random placement
- **Solution:** Test multiple games, use fixed seed `seed(12345)` for reproducible tests, observe patterns

**2. Destruction Mechanic**
- Multiple edge cases (multiple matches, empty rows, dice shifting)
- **Solution:** Add print statements to verify arrays match what's displayed on screen

**3. Score Verification**
- Complex formula: count × value × count
- **Solution:** Use calculator, pre-calculate expected scores, add debug prints

**4. Limited Platform Access**
- Only 1 Mac and 2 Linux testers
- **Solution:** Focus on Windows, test critical features only on other platforms

### Testing Timeline

| Day | Tasks | Who | Hours |
|-----|-------|-----|-------|
| **Nov 30** | Setup test tracking, write test documentation |Seth,  Harman | 5 |
| **Dec 1** | UI and Classic Mode testing | Joseph, Abhi, Gary | 10 |
| **Dec 2** | Hot Dice and AI testing | Abhi, Joseph, Gary | 12 |
| **Dec 3** | Cross-platform testing (Mac/Linux), bug fixes | Joseph, Abhi, Gary, Seth | 10 |
| **Dec 4** | Retest everything (regression) | Joseph, Abhi, Gary | 8 |
| **Dec 5** | Final fixes | Joseph, Gary | 5 |

### Test Process

**Roles:**
- **Test Lead (Joseph):** Organize testing, track progress, write final report
- **Testers (All):** Play game following test cases, document pass/fail, report bugs
- **Bug Fixers (Joseph, Abhi and Gary):** Fix critical bugs found during testing

**How to Test:**
1. Read what the test case is checking
2. Launch game fresh
3. Play through the steps
4. Check if results match expectations
5. Mark pass or fail
6. If fail: take screenshot, write bug report in GitHub Issues
7. Add print statements in code to verify internal values if needed

**Example Print Statements:**
```gdscript
print("Player 1 score: ", playerScore())
print("Player 1 grid: ", player1_rows)
print("Current roll: ", current_roll)
```

### Test Cases Summary

**52 Total Test Cases:**

| Category | Count | What We're Testing |
|----------|-------|-------------------|
| UI and Navigation | 15 | Menus, buttons, screen layouts, navigation |
| Core Mechanics | 20 | Rolling, placement, destruction, turn switching |
| Scoring System | 8 | Multiplier formula, score updates |
| AI Behavior | 6 | AI makes reasonable moves, timing |
| Hot Dice Specific | 10 | HP, Cash In, healing, health bars |
| Classic Mode | 8 | Column placement, board-full detection |
| Win Conditions | 5 | Game ends correctly, winner shown |

### Test Case List

#### UI and Navigation (15)
- TC-UI-001: Main menu shows title and two buttons
- TC-UI-002: "Hot Dice" button goes to options menu
- TC-UI-003: "Classic" button goes to options menu
- TC-UI-006: "Two Player" sets playerNumber=2
- TC-UI-007: Classic screen has rotated grids, scores visible
- TC-UI-008: Hot Dice screen has health bars, straight grids
- TC-UI-012: Game Over shows winner correctly
- TC-UI-013: "Play Again" restarts same mode
- TC-UI-015: Can navigate through all screens without errors

#### Core Mechanics (20)
- TC-MECH-001: Roll button gives random 1-6
- TC-MECH-006: Both grids start empty
- TC-MECH-009: Can't place on occupied space
- TC-MECH-011: Classic mode fills columns bottom-to-top
- TC-MECH-012: Hot Dice mode places exactly where clicked
- TC-MECH-016: Placing matching die destroys one opponent die
- TC-MECH-017: Destroys ALL matching dice in row
- TC-MECH-019: Remaining dice shift down after destruction

#### Scoring (8)
- TC-SCORE-001: One die scores its value (6 = 6 points)
- TC-SCORE-002: Two matching score 2×V×2 (two 6s = 24)
- TC-SCORE-003: Three matching score 3×V×3 (three 6s = 54)
- TC-SCORE-004: Mixed row adds scores separately
- TC-SCORE-006: Score updates immediately after placement

#### AI Behavior (6)
- TC-AI-001: AI takes turn automatically
- TC-AI-002: Classic AI makes strategic choices (test 10 turns)
- TC-AI-003: Hot Dice AI places randomly
- TC-AI-005: AI cashes in ~30% of the time (test 20 opportunities)
- TC-AI-006: Can complete full game vs AI

#### Hot Dice (10)
- TC-HD-001: Both players start at 100 HP
- TC-HD-006: Cash In deals damage = board score
- TC-HD-007: Cash In clears all your dice
- TC-HD-009: Destroying opponent's 1 heals them +1 HP
- TC-HD-010: Game ends when anyone reaches 0 HP

#### Classic Mode (8)
- TC-CM-001: Three column buttons work
- TC-CM-002: Dice fill bottom-to-top in columns
- TC-CM-004: Game detects when board is full (9/9)
- TC-CM-006: Highest score wins
- TC-CM-007: Equal scores show "Its a draw!"

#### Win Conditions (5)
- TC-WIN-001: Classic ends when board full, highest score wins
- TC-WIN-002: Hot Dice ends at 0 HP
- TC-WIN-003: Shows correct "Player X Wins!" text
- TC-WIN-004: Transitions to Game Over screen

---

## Test Infrastructure

### Software and Environment

**Platforms:**
- Primary: Windows 10/11 (all 5 members)
- Secondary: macOS (Joseph only)
- Secondary: Linux Ubuntu 22.04 (Abhi, Seth)

**Tools:**
- Godot 4.5 for development testing
- Exported .exe/.app for release testing
- OBS Studio for recording bugs
- GitHub Issues for bug tracking
- Google Sheets for test tracking

**No Automated Testing:** Everything is manual

### How Manual Testing Works

**No Test Scripts:** We just play the game and check if things work

**Testing Process:**
1. Launch game
2. Follow test case steps (play through the scenario)
3. Observe what happens
4. Compare to what should happen
5. Mark pass/fail
6. If something's wrong, take screenshot and file bug report

**Example Test:**
- Test: "Verify rolling gives 1-6"
- How to test: Click Roll button 20 times, check all values are 1-6
- Pass: All rolls between 1-6
- Fail: Got a 0 or 7

**Using Print Statements:**
When we can't see internal values (like arrays), we add temporary print statements:
```gdscript
print("P1 grid: ", player1_rows)
print("Score calculation: ", calculate_row_score(player1_rows[0]))
```

### Version Control

**Testing Branch:** Use  'conflict_fix' branch (code frozen during testing timeline)

**Process:**
1. Before testing: Update `conflict_fix'` from `dev`
2. During testing: No code changes, just test
3. Bug fixes: Create fix in `dev` branch, then update `conflict_fix` and retest
4. After passing: Merge `conflict_fix` to `main`

### File Organization

```
high-rollers/
├── Documentation/
│   └── Testing/
│       ├── testplan.md (this document)
├── (game files)
```


## Appendix: Detailed Test Cases

**Note:** 8 example test cases shown below. Remaining 44 are listed by name in the test case list above.

### TC-UI-001: Main Menu Display

**What:** Check main menu looks correct

**Requirements:** Section 6.2 Main Menu

**How to Test:**
1. Launch High Rollers
2. Look at main menu

**Expected:**
- Title says "High Rollers" (big text)
- "Hot Dice" button visible
- "Classic" button visible
- Dark gray background
- Buttons respond to mouse hover

**Pass:** All elements present and correct  
**Fail:** Missing elements or wrong text



### TC-MECH-001: Dice Roll Generation

**What:** Check rolling gives random 1-6

**Requirements:** Section 5.1 Dice Rolling

**How to Test:**
1. Start any game mode
2. Click "Roll" button 20 times (restart between each)
3. Write down all 20 values

**Expected:**
- All values between 1-6
- Values look random (not all same, not sequential)
- Die picture matches number

**Pass:** All 20 rolls are 1-6, appear random  
**Fail:** Got 0, 7, or pattern like all 3s

**Debug:**
```gdscript
print("Rolled: ", current_roll)
```


### TC-MECH-016: Single Die Destruction

**What:** Check placing matching die destroys opponent's die

**Requirements:** Section 5.4 Destruction

**How to Test:**
1. Start Hot Dice, Two Player
2. P1 places 5 in Row 0
3. P2 places 3 in Row 0
4. P1 gets a 3 (keep rolling until you get it)
5. P1 places 3 in their Row 0
6. Look at P2's Row 0

**Expected:**
- P2's die (value 3) disappears from Row 0
- P2's score goes down
- Console shows updated array

**Pass:** Die removed, score updated  
**Fail:** Die still there, or wrong die removed

**Debug:**
```gdscript
print("P2 Row 0 before: ", player2_rows[0])
print("P2 Row 0 after: ", player2_rows[0])
```



### TC-SCORE-003: Three Matching Dice

**What:** Check score for three same dice = 3×V×3

**Requirements:** Section 5.5 Scoring

**How to Test:**
1. Start any mode, Two Player
2. Get three 6s in P1's Row 0
   - Place 6, then 6, then 6
3. Look at P1's score

**Expected:**
- Score shows 54 points (3×6×3 = 54)
- Console confirms: 54

**Pass:** Score = 54  
**Fail:** Score wrong

**Debug:**
```gdscript
print("Row 0: ", player1_rows[0])
print("Row 0 score: ", calculate_row_score(player1_rows[0]))
```



### TC-HD-009: Dice-1 Healing

**What:** Check destroying opponent's 1 heals them +1 HP

**Requirements:** Section 5.6 Healing

**How to Test:**
1. Start Hot Dice, Two Player
2. Get P1 HP to about 50 (use Cash In)
3. P1 places a 1 in Row 0
4. P2 gets a 1 (keep rolling)
5. P2 places 1 in their Row 0
6. Watch P1's health bar

**Expected:**
- P1 HP goes up by 1 (50 → 51)
- Green flash animation
- Console confirms HP change

**Pass:** HP +1, animation plays  
**Fail:** HP didn't change, or no animation

**Debug:**
```gdscript
print("P1 HP before: ", player1_health)
print("P1 HP after: ", player1_health)
```

### TC-AI-002: Classic AI Strategy

**What:** Check AI makes smart moves in Classic

**Requirements:** Section 5.8 AI Behavior

**How to Test:**
1. Start Classic, One Player
2. Play 10 turns
3. Watch what AI does each turn
4. Check if moves make sense:
   - Does it avoid full columns?
   - Does it match its own dice when possible?
   - Does it destroy your dice when possible?

**Expected:**
- AI never picks full columns
- AI usually picks strategically (70%+ of turns)
- Decisions make sense

**Pass:** Most moves look smart  
**Fail:** AI picks randomly or picks full columns

**Observation Checklist:**
- [ ] AI avoided full columns (all 10 turns)
- [ ] AI matched own dice (when available)
- [ ] AI destroyed opponent dice (when possible)



### TC-CM-004: Board Full Detection

**What:** Check game ends when board fills up

**Requirements:** Section 4.4 Win Conditions

**How to Test:**
1. Start Classic, Two Player
2. Play until P1 has 8/9 spaces full
3. P1 places final die
4. Watch what happens

**Expected:**
- Game ends immediately
- Game Over screen appears
- Shows correct winner
- No delay or freezing

**Pass:** Game ends right away, correct winner  
**Fail:** Game doesn't end, or wrong winner

**Debug:**
```gdscript
print("Filled spaces: ", count_filled(player1_rows))
print("Game over: ", game_over)
```



### TC-WIN-002: Hot Dice Victory

**What:** Check game ends when HP reaches 0

**Requirements:** Section 5.6 Win Condition

**How to Test:**
1. Start Hot Dice
2. Get P2 HP to below 30
3. Build P1 score to 30+
4. P1 clicks "Cash In"
5. Watch P2's health bar

**Expected:**
- P2 HP drops to 0 (not negative)
- Health bar empties
- Game Over screen appears
- Shows "Player 1 Wins!"

**Pass:** Game ends at 0 HP, correct winner  
**Fail:** Game continues, or wrong winner

**Debug:**
```gdscript
print("P2 HP before: ", player2_health)
print("Damage: ", score)
print("P2 HP after: ", player2_health)
print("Game over: ", game_over)
```


## Summary

This test plan describes manual testing for High Rollers. We play the game following 52 test cases to verify all features work correctly. Testing takes 1 week with 5 team members playing through different scenarios, checking results, and reporting bugs. We use print statements in code to verify internal values when needed.

**Total Test Cases:** 52  
**Detailed Examples:** 8 (shown above)  
**Testing Approach:** Manual gameplay with observation and verification  
**Duration:** 1 week (Nov 30 - Dec 5)  
**Success Criteria:** 0 critical bugs, 90%+ tests pass


