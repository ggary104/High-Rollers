# CSCI 265 Design Document 

## Team name: The High Rollers

## Project/Product name: The High Rollers

## Contact person and email address

Seth, seth.william.doyle@gmail.com

## Table of Contents

* Design Overview
* Logical Design
	* Main Menu
	* Hot Dice
		* Game Logic Process
		* Components
			* Dice
			* Dice Effects
			* Action Buttons
			* Dice Tile
			* Dice Grid
			* AI Opponent
			* Health
			* Game Over
			* UI Elements
	* Classic
		* Game Logic Process
		* Components
			* Dice
			* Grid
			* Dice Deletion
			* Game Over
			* UI Elements
* Implementation
	* Godot
	* Main Menu
	* Hot Dice
	* Classic Mode
* Appendices 

## Design Overview

High Rollers (the product, not the team) is a video game based around strategically placing dice in a grid to get a higher score than your opponent. The two game modes, Hot Dice and Classic, each explore variants of this idea. Both game modes can be played against either an AI or a second human player. 

List of game elements (across both game modes):  
* A main menu that allows choosing between game modes and player numbers  
* Dice used for scoring  
* Dice mechanics  
* Grid for each player to place their dice  
* Buttons for player actions (Rolling, cashing in, skipping turn, re-rolling)  
* Health system  
* Game-over detection  
* Sound effects (for player feedback)  
* Music (mainly for mood)

Below is a really simple DFD of the program as a whole.

![A very bare dfd](/images/dfd.png)

## Logical Design

High Rollers uses a top-down object-oriented approach to design. This meshes well with Godot, our chosen game engine, which emphasizes a node-based structure. 

### Main Menu

The main menu has two main purposes: choosing game settings and transitioning to a main game scene. In terms of game settings, players should be able to choose their game mode (either Hot Dice or Classic) and player count (either a 1 player game against an AI opponent or a 2 player game against a human opponent). After players have chosen their settings, they should be able to transition to a main game scene in accordance with those settings. 

The game mode has to be either Hot Dice or Classic (it can’t be both). Therefore we can use some form of toggle system to switch between the game modes, with the toggle changing some gamemode variable. A similar design can be used to switch between player counts. 

The transition to a game scene can be done using a button. The game scene depends on the value of the gamemode variable. The value of the playercount variable can be passed to some global script. 

### Hot Dice

Hot Dice is one of the two game modes accessible by the player. It differs from classic mode by changing certain mechanics (such as the dice grid) and introducing new ones (such as a health and attack system). It is hoped that the increase in mechanics will result in mechanics interacting in interesting ways and thus creating more depth in the gameplay. 

#### Game Logic Process: 

1. Initialize gameplay  
   1. Set health of players to the max value  
   2. Spawn dice tiles  
   3. Randomize player turn  
2. Repeat until game over detected  
   1. Player takes their turn  
   2. Check for game over (either go to step 3 or continue)  
   3. Switch player turn  
   4. Go back to step 2  
3. Show game over screen  
     
   
#### Components:

##### Dice: 

Dice are able to be any one of six possible types (D1-6). Dice have different score values and effects based on their type. Dice are a core game mechanic and are further elaborated on in the following sections.

##### Dice effects:

###### D1: 

When destroyed (either through being cashed in or through D4’s effect) increase the health of the player who destroyed it by one.

###### D2: 

When placed in the grid, double the score values of all dice in its column. Good for increasing score, but has negative synergy with D6.

###### D3: 

When placed in the grid, gives the player the ability to reroll (see rerolling). 

###### D4: 

When placed in the grid, destroy a dice in the other player’s grid. The dice destroyed will be in the same row as the D4, but in the opposite column (e.g. if player 1 placed a D4 in the top right of his grid, the dice in the top left of player 2’s grid will be destroyed). 

###### D5: 

Has no special effect. Useful for unconditional scoring. 

###### D6: 

Score value increases based on the average face value of the dice in the grid. The formula for calculating D6’s score value is sv \= 6 \+ 2 \* (ra \- 3.5), where sv is D6’s score value and ra is the average value of the grid dice rounded to the nearest 0.5. D6’s score value will update in accordance with the grid average changing.

##### Action Buttons:   

###### Roll Button:

When selected, spawns a dice. The player can then either place their dice within their grid or skip their turn. Rolling a dice renders the player unable to cash in their score. If the player’s grid is full, they will be unable to roll and be forced to cash in.

###### Cash In Button: 

When selected, the player will “cash in” their score, decreasing their opponent’s health by their score value. Cashing in ends the player’s turn. The player can only cash in if they have at least one dice in their grid. 

###### Skip Turn Button: 

Ends the player’s turn.. Can only be selected once the player rolls the dice. Mainly used to avoid placing low-value dice in the grid. 

###### Reroll: 

Reroll’s the player’s dice. Can only be selected once the player has rolled a dice and the player has the ability to reroll (from D3’s effect). Rerolling makes the player unable to reroll until they place another D3. 

##### Dice Tile: 

When clicked, the player’s current dice is placed on the dice tile. The player can only place dice on their dice tiles. A dice tile can only hold one dice at a time. If clicked when already holding a dice, does nothing. Usually part of a dice grid.

##### Dice Grid: 

A collection of 9 dice tiles arranged in a square grid. The score values of dice placed in the grid are added to the player’s score. When two dice with the same face value are placed in the same row, their total score is three times their score value (e.g. two D5s in the same row have a combined score of 15). Similarly, when three dice with the same face value are placed in the same row, the resulting score will be six times their score value.

##### AI Opponent: 

When playing a 1 player game, the player should face off against an AI opponent. The AI opponent’s moves should be logical, but still influenced by some form of randomness, to fit into the strategy-luck theme of the game. Whenever the AI makes a move, there should be some form of feedback to clearly communicate the decision to the player. 

##### Health: 

Each player starts the game with a set amount of health. Health is decreased through attacks from the other player and increased through D1’s effect. A player cannot have more than their starting health. When either player’s health reaches zero, it triggers a game over.

##### Game Over: 

The game over screen should show which player won the previous game. It should then prompt the player to either play again (using the same settings as before) or return to the main menu (to try a different game mode). 

##### UI Elements:

UI elements will be used to communicate important information to the player, primarily that which impacts decision-making.

###### Score Display: 

As the score of the player and their opponent is a large factor in decision-making, they should be clearly displayed at all times and accurately reflect the actual score value. Hiding the score value would just make the game more tedious, as to make optimal decisions one would need to calculate both player’s scores every turn.

###### Health Meter: 

Following similar logic to the score display, each player should know both health values at all times. The health values highly influence decision making, such as when to cash in, whether to use D6’s effect, etc.

###### Turn Indicator: 

A turn indicator ensures that neither player is mistaken as to whose turn it is. 

### Classic

Classic mode is the second of the two game modes in High Rollers. It differs from hot dice by being more streamlined and therefore having higher levels of cohesion in its mechanics. Its simplicity adds to its appeal, as it more closely resembles a real, physical dice game.

While similar in design to hot dice, it differs in a number of key ways.

#### Game Logic Process:

1. Initialize gameplay  
   1. Randomize player turn  
2. Repeat until game over detected  
   1. Generate random dice  
   2. Player takes their turn  
   3. Check for game over (either go to step 3 or continue)  
   4. Switch player turn  
   5. Go back to step 2  
3. Show game over screen  
   

#### Components:

##### Dice: 

Dice are randomly generated and can be any value between 1-6. Dice value is added to player score when placed in the player’s grid. 

##### Grid: 

Three horizontal rows arranged vertically. Each row can contain up to 3 dice. The order of the dice within each row is irrelevant. The score values of dice placed in the grid are added to the player’s score. When two dice with the same face value are placed in the same row, their total score is three times their score value (e.g. two D5s in the same row have a combined score of 15). Similarly, when three dice with the same face value are placed in the same row, the resulting score will be six times their score value.

##### Dice Deletion: 

When a dice of value x is placed in a player’s row, destroy all dice placed in the opponent’s corresponding row (e.g. if player 1 placed a 5 in their top row, all 5s in player 2’s top row get destroyed).   
AI Opponent: When playing a 1 player game, the player should face off against an AI opponent. The AI opponent’s moves should be logical, but still influenced by some form of randomness, to fit into the strategy-luck theme of the game. Whenever the AI makes a move, there should be some form of feedback to clearly communicate the decision to the player. 

##### Game Over: 

When either player’s board becomes full (i.e. each of the three rows have three dice) it triggers a game over. The winner of the game is determined by whoever has the highest score when the game is over. Should use the same game over screen as hot dice. 

##### UI Elements:

###### Score display: 

See hot dice score display.

###### Turn indicator: 

See hot dice turn indicator.

## Implementation

### Godot:

The team has chosen to build the project in the Godot game engine, as it’s free, easy to learn, and very powerful. High Rollers takes full advantage of Godot’s capabilities, using its built-in nodes to simplify many aspects of development. Provided is a list of examples of ways Godot has been used to implement features:

* Sprite2D and TextureRect nodes are used to simplify graphical display.  
* Godot’s control nodes are used to arrange UI elements on the screen.  
* Button nodes are used for (most of) the game’s clickable buttons/elements.  
* AudioStreamPlayer nodes are used for sounds and music.  
* Godot’s built-in editor is used to test/debug the game.  
* Theme Overrides are used to visually style most of the buttons and UI elements.

### Main Menu

![](/images/mainmenunodetree.png)

The **Main Menu** node (of type Control) serves as the root node of the scene. It is the only node with an attached script (mainmenu.gd), so it also controls all menu logic.

The **ColorRect** serves as a background. 

The **VBoxContainer** serves to arrange the elements vertically, in the same way they’re laid out in the scene tree (e.g. The Label is above the HBoxContainer, HBoxContainer2 is above HBoxContainer3). 

The **Label** displays the name of the game (“High Rollers”).

The **HBoxContainers** arrange their children from left to right (e.g. HotDiceButton is to the left of the ClassicButton). 

The settings buttons (**HotDiceButton, ClassicButton, OnePlayerButton, TwoPlayerButton**) change the values of selected\_game\_mode and player\_count respectively. They can be in either one of two states: selected or unselected. When a button is selected, it becomes disabled and visually changes to reflect being selected. When a button is unselected, it stops being disabled and visually changes to reflect being unselected. Buttons can transition from unselected to selected by being clicked. Doing so makes the other button in its row unselected. 

By default, selected\_game\_mode is GAME\_MODE.HOT\_DICE (1) and player\_count is one. To reflect this, HotDiceButton and OnePlayerButton are by default “selected” and ClassicButton and TwoPlayerButton are “unselected”. When a button transitions from unselected to selected, it sets selected\_game\_mode to the appropriate value (e.g. HotDiceButton sets it to GAME\_MODE.HOT\_DICE). 

We make use of the built-in pressed() signal in Godot to connect the button being clicked to mainmenu.gd, where the button logic is handled.

**StartButton** changes the current scene from MainMenu.tscn to one of the main game scenes (Game.tscn, Classic.tscn). The paths to the game scenes are stored within mainmenu.gd as constant strings. 

The **AudioStreamPlayer** (Click\_SFX) plays a clicking sound whenever a non-disabled button is clicked.  

### Hot Dice

![](/images/hotdicenodetree.png)

The **Game** node (of type Node2D) is the root node of the scene. Its attached script (game.gd) oversees all game logic.

The **CanvasLayer** node (UI-Elements) mainly serves to organize the UI nodes in the node tree.

The Label nodes (**Player1Score** and **Player2Score**) display the score values for their respective players. The score values are calculated by each player’s DiceGrid before being passed to game.gd which then sets the Text value for each label. As with the majority of UI elements, its visuals are styled using Theme Overrides.

The VBoxContainer nodes and the HboxContainer nodes (**Player1\_UI** and **Player2\_UI**) are used to arrange UI elements in the screen, as seen in the main menu. 

ProgressBar nodes (**Player1Health** and **Player2Health**) are used to display health values for each player. Each health bar also has their value displayed as text, so that players can make more informed decisions. Health for each player is calculated by game.gd before being passed to each health bar. 

The Button nodes (**Player1RollButton, Player2ReRollButton, Player1CashInButton, Player1SkipButton**, and their Player2 variants) are used for performing the majority of the player interactions. Similar to the menu buttons, the pressed() signal is used to communicate with game.gd that the button has been clicked. The disabled property built-in to the Button node is used to ensure that the buttons can’t be clicked when they aren’t supposed to. Theme Overrides are used to make a visual distinction between a disabled and non-disabled state, with a disabled button appearing grayed-out. Since buttons can only be active during a player’s turn, and since at least one button is active at any time, this also serves as a form of turn indication. 

**Roll Button:** Upon the start of a player’s turn, their roll button will have their disabled property set to false. When the player clicks either the roll button or the cash in button, the roll button’s disabled property will be set to true. When the roll button is clicked, it will call the roll\_dice() function. 

The roll\_dice() function instantiates Dice.tscn, adds it as a child of the Game node, and assigns it a face value between 1-6. Then it sets the dice’s position to DiceSpawnPosition, sets the current\_dice variable to the current dice, and enables the dice grid of the player. 

**Cash In Button:** Upon the start of a player’s turn, their cash-in button will have their disabled property set to false. When the player clicks either the roll button or the cash in button, the cash-in button’s disabled property will be set to true. When clicked, the cash-in button calls the perform\_cash\_in() function. 

The perform\_cash\_in() function gets the player’s grid score, subtracts it from their opponent’s health, clears the player’s board and calls the switch\_turn() function.  

**Skip Turn Button:** When the player rolls a dice, the skip turn button’s disabled property is set to false. Either clicking the skip turn button or placing the dice on the grid disables the skip turn button. Clicking the skip turn button calls the skip\_turn() function.

*Note about health:* Whenever a player's health value changes, a function is automatically called (using Godot’s built-in setter functions) that checks whether either player’s health is 0 or less. If it is, a game over is triggered.

The skip\_turn() function destroys the current dice, sets the current\_dice variable to null, and calls the switch\_turn() function. 

**Reroll Button:** By default, the reroll button has its visible property set to false. When the player rolls a dice and the player(x)\_can\_reroll variable is set to true, the reroll button’s visible property is set to true and the roll button’s visible property is set to false. This gives the impression that the roll button “becomes” the reroll button, which is fitting considering the two buttons perform functionally the same action. When the reroll button is clicked or the player places their dice on their grid, the reroll button becomes invisible and the roll button becomes visible. Clicking the reroll button calls the perform\_reroll() function.

The perform\_reroll() function destroys the current dice, sets the current\_dice variable to null, sets the player(x)\_can\_reroll variable to false, and calls the roll\_dice() function. 

The **Board** node (of type Node2D) is used for organizing the scene tree.

The **DiceGrid** nodes instantiate row\_size ^2 (as row\_size is 3, this value is 9\) DiceTiles as children and arrange them in a grid pattern. Clicking an individual dice tile within the player’s dice grid emits the selected signal passing a reference to itself, which is picked up by the dice grid, which then emits another signal passing the reference to the dice tile, which is then caught by game.gd which calls the place\_dice() function. Most logic relating to the dice grid is done within the dice grid itself (using the attached dice\_grid.gd script).

The place\_dice() function sets the current dice’s position to the tile’s position. If the current dice’s face value is 4, then it calls a function that carries out its effect. If the current dice’s face value is 3, then it sets the player(x)\_can\_reroll variable to true. Then it sets the dice tile’s dice property to current\_dice, disables the tiles in the player’s dice grid, updates the current dice grid’s score average, sets current\_dice to null and switches turns.

The Marker2D node (**DiceSpawnPosition**) is a reference to a position near the middle of the screen. When a dice is spawned, its position is set to the Marker2D’s position.

The **DiceBackground** (of type Node2D) is a purely visual element serving as the game’s background. Every 0.2 seconds, the DiceBackground creates an instance of a BackgroundDice.tscn as a child and sets its position to near the bottom of the screen. The BackgroundDice are of type AnimatedSprite2D. When created, they randomize their properties and slowly move upwards. When they go past the top of the screen, they delete themselves. This creates the illusion of an infinitely scrolling background.

The **AI logic** is done entirely within game.gd. It makes decisions by assigning each choice a value, and choosing the option that yields the highest value. Some decisions are conditional on a randomly generated number being above/below a certain value, giving an element of unpredictability to the game.

The **AudioManager** node (of type node) is mainly used to organize and access its children, the AudioStreamPlayers (Roll\_SFX, Place\_SFX, etc). Each AudioStreamPlayer uses an AudioStreamRandomizer to vary the pitch of each sound effect. Sound effects are used for rolling dice, placing dice, skipping turns, cashing in, healing, and destroying dice. 

### Classic Mode:

![](/images/classicnodetree.png)

The **Classic** node (of type Node2D) is the root node of the scene. Its attached script, game.gd, handles most of the game logic.

The **CanvasLayer** node (UI-Elements) mainly serves to organize the UI nodes in the node tree.

The **Player(x)Score** nodes (of type Label) display each player’s current score. Their values are calculated by classic.gd.

The **Player(x)RollButton** (of type Button) is enabled at the start of the player’s turn. When clicked, it calls the roll\_dice() function, then disables itself. 

The roll\_dice() function starts the dice roll animation, then sets the current\_roll variable to a random integer from 1 to 6\. 

The **Player(x)Roll** (of type TextureRect) displays the texture of the currently rolled dice. Its texture is set by the update\_ui() function in the Game node.

The update\_ui() function is called at the end of most functions to ensure the visuals of the board match the values of game.gd. 

The Sprite2D (**DiceRoll**) is an animation that occurs when the player rolls a dice that mimics the physical rolling of a dice. This is primarily done through its child AnimationPlayer (RollAnimation).

The PanelContainer nodes (**Player1Board** and **Player2Board**) arrange their children within their bounding box.

The GridContainer nodes (**Player1Grid** and **Player2Grid**) hold the TextureRects used for displaying the dice on the board and arrange them in a grid. When the game starts, the GridContainer instantiates 9 TextureRects and adds them as children. The texture for the TextureRects is done through the classic.gd script. 

The HBoxContainer nodes (**Player1ColumnInputs** and **Player2ColumnInputs**) arrange their children horizontally. However, at the start of the game they are turned 90 degrees so that the column buttons are arranged vertically. This is an artifact from when the design in mind used columns instead of rows.

The **ColumnButton** nodes (of type Button) each correspond to a column (or row) of the player’s grid. When clicked, they place the current dice (if available) in the relevant column/row, then disable themselves. 

The **AI logic** is similar to that of Hot Dice. Before deciding which row to place the dice, the AI will calculate the resulting score of each possible decision, and choose the one that yields the highest score. 

The **ColorRect** node (Background) is used to create a background of a solid color. 

## Appendices

### Sounds effects and music:  
All audio was sourced from the internet. The audio is royalty-free and needs no attribution. 