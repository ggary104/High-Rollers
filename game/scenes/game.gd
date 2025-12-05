# scripts/Game.gd
extends Node2D


var DiceObject := preload("res://scenes/dice.tscn")
var player_turn: int = randi() % 2  + 1 #Is it player1's turn or player 2s

var is_player2_human: bool = false
var game_over: bool = false 
var dice_textures: Array = []
var current_dice: Dice = null

const MAX_HEALTH: int = 100
var player1_health: int = MAX_HEALTH:
	set(value):
		player1_healthbar.value = value
		health_change_animation(value, player1_health, 1)
		check_game_over(value, 1)
		print(player1_health)
		print(value)
		print("ow")
		player1_health = value

var player2_health: int = MAX_HEALTH:
	set(value):
		player2_healthbar.value = value
		health_change_animation(value, player2_health, 2)
		check_game_over(value, 2)
		print(value)
		print("oof")
		player2_health = value

var player1_can_reroll: bool = false
var player2_can_reroll: bool = false



# Variables used in labels to display the scores and Which Players Turn Is It
# On ready -> They need to load when the labels are loaded 
@onready var player1_score_label = $"UI-Elements/Player1Score" as Label
@onready var player2_score_label = $"UI-Elements/Player2Score" as Label
@onready var player1_roll_button = $"UI-Elements/Player1_UI/Player1RollButton" as Button
@onready var player2_roll_button = $"UI-Elements/Player2_UI/Player2RollButton" as Button
@onready var player1_skip_button = $"UI-Elements/Player1_UI/Player1SkipTurnButton" as Button
@onready var player2_skip_button = $"UI-Elements/Player2_UI/Player2SkipTurnButton" as Button
@onready var turn_indicator_label = $"UI-Elements/TurnIndicator" as Label
@onready var player1_dice_grid = $Board/DiceGrid as DiceGrid
@onready var player2_dice_grid = $Board/DiceGrid2 as DiceGrid
@onready var dice_spawn_position = $Board/DiceSpawnPosition as Marker2D
@onready var computer_thoughts = $"UI-Elements/ComputerThoughts" as Label

#Variable for player 1 and player 2 cash in button used for attacking the health
@onready var player1_cash_in_button = $"UI-Elements/Player1_UI/Player1CashInButton" as Button
@onready var player2_cash_in_button = $"UI-Elements/Player2_UI/Player2CashInButton" as Button
@onready var player1_healthbar = $"UI-Elements/VBoxContainer/Player1Health" as ProgressBar
@onready var player2_healthbar = $"UI-Elements/VBoxContainer2/Player2Health" as ProgressBar

#Re-Roll Buttons for dice 3 effect
@onready var player1_reroll_button = $"UI-Elements/Player1_UI/Player1ReRollButton" as Button
@onready var player2_reroll_button = $"UI-Elements/Player2_UI/Player2ReRollButton" as Button
@onready var audio_manager = $AudioManager as AudioManager


func _ready() -> void:
	
	player1_dice_grid.on_tile_selected.connect(place_dice)
	player2_dice_grid.on_tile_selected.connect(place_dice)
	
	player1_roll_button.disabled = true
	player2_roll_button.disabled = true
	player1_cash_in_button.disabled = true
	player2_cash_in_button.disabled = true
	player1_skip_button.disabled = true
	player2_skip_button.disabled = true
	player1_reroll_button.visible = false
	player2_reroll_button.visible = false
	
	player1_health = MAX_HEALTH
	player2_health = MAX_HEALTH
	
	if GameManager.playerNumber == 1:
		is_player2_human = false
	else:
		is_player2_human = true
	
	if player_turn == 1:
		player1_turn()
	else:
		player2_turn()
	


func player1_turn() -> void:
	
	player2_roll_button.disabled = true
	player2_roll_button.visible = true
	player2_cash_in_button.disabled = true
	player2_skip_button.disabled = true
	player2_reroll_button.visible = false
	
	player1_roll_button.disabled = false if not player1_dice_grid.is_full() else true
	
	player1_cash_in_button.disabled = false if not player1_dice_grid.get_grid_score() == 0 else true
	
	player2_skip_button.disabled = true
	
	update_ui()


func player2_turn() -> void:
	update_ui()
	
	player1_roll_button.disabled = true
	player1_roll_button.visible = true
	player1_cash_in_button.disabled = true
	player1_skip_button.disabled = true
	player1_reroll_button.visible = false
	
	if is_player2_human:
		player2_roll_button.disabled = false if not player2_dice_grid.is_full() else true
		
		player2_cash_in_button.disabled = false if not player2_dice_grid.get_grid_score() == 0 else true
	else:
		computer_turn()


func _on_roll_button_pressed() -> void:
	if game_over:
		return
	
	var current_grid: DiceGrid = player1_dice_grid if player_turn == 1 else player2_dice_grid
	var is_current_grid_full: bool = current_grid.is_full()
	if is_current_grid_full:
		return
	
	roll_dice()
	
	if player_turn == 1:
		player1_roll_button.disabled = true
		player1_cash_in_button.disabled = true
		player1_skip_button.disabled = false
		player1_reroll_button.visible = player1_can_reroll
		player1_roll_button.visible = not player1_can_reroll
	else:
		player2_roll_button.disabled = true
		player2_cash_in_button.disabled = true
		player2_skip_button.disabled = false
		player2_reroll_button.visible = player2_can_reroll
		player2_roll_button.visible = not player2_can_reroll


func roll_dice() -> void:
	var current_roll: int = randi() % 6 + 1;
	var dice: Dice = DiceObject.instantiate()
	add_child(dice)
	
	audio_manager.roll_sfx.play()
	
	if current_roll == 6:
		var current_player_grid: DiceGrid = (
				player1_dice_grid if player_turn == 1 
				else player2_dice_grid
		)
		
		dice.set_score_value(6)
		
		var dice_6_value: int = current_player_grid.get_adjusted_6_value()
		
		dice.score_value = dice_6_value

	else:
		dice.set_score_value(current_roll)
	
	dice.position = dice_spawn_position.position
	dice.on_dice_1_destroyed.connect(dice_1_effect)
	current_dice = dice
			
	if player_turn == 1:
		player1_dice_grid.enable_tiles()
	elif player_turn == 2 and is_player2_human:
		player2_dice_grid.enable_tiles()
	
	update_ui()


func place_dice(tile: DiceTile) -> void:
	if not tile.dice == null:
		return
	
	var tile_position: Vector2 = tile.global_position
	current_dice.position = tile_position
	
	#print_player_grids()
	
	if current_dice.face_value == 4:
		remove_opponent_dice(tile.index)
	
	if current_dice.score_value == 3:
		if player_turn == 1:
			player1_can_reroll = true
		
		elif player_turn == 2:
			player2_can_reroll = true
	
	var current_dice_grid: DiceGrid = player1_dice_grid if player_turn == 1 else player2_dice_grid
	if current_dice_grid.is_enabled:
		current_dice_grid.disable_tiles()
	
	audio_manager.place_sfx.play()
	tile.dice = current_dice
	current_dice_grid.set_dice_6_score()
	current_dice = null
	switch_turn()

func computer_turn() -> void:
	if game_over: 
		return
	# disable player roll button
		
	var is_current_grid_full: bool = player2_dice_grid.is_full()
	await get_tree().create_timer(0.5).timeout
	computer_thoughts.text = "Should I cash in...?"

	if is_current_grid_full || await should_computer_cash_in():
		await computer_cash_in()
		return # Turn ends after cash i
	
	await get_tree().create_timer(.8).timeout  # delay before roll
	roll_dice()
	
	computer_thoughts.text = "Can I re-roll...?"
	await get_tree().create_timer(0.25).timeout

	if should_computer_reroll():
		await get_tree().create_timer(0.5).timeout
		computer_thoughts.text = "Computer is rerolling..."
		perform_reroll() 
		await get_tree().create_timer(0.5).timeout 
	
	computer_thoughts.text = "Should I skip...?"
	await get_tree().create_timer(0.25).timeout
	if should_computer_skip_turn():
		await computer_skip_turn()
		computer_thoughts.text = ""
		return
	
	var choice: Vector2i = computer_choice() # This returns us the best column.
	
	# Safety check: Ensure we got a valid column
	if choice.x == -1: 
		choice = Vector2i(0,0)
		
	var tile_to_place: DiceTile = null # Which row is empty
	
	for row in range(3):
		var t = player2_dice_grid.get_tile(Vector2i(choice.x, row))
		if t.dice == null:
			# Get the first empty row in the decided column
			tile_to_place = t
			break
			
	if tile_to_place:
		
		place_dice(tile_to_place)
	else:
		# Safety Check: If for some reason computer chooses a column which is full or the whole board is full and it didn't cash in -> Just cash in
		print("Error: Computer tried to place on full column")
		await computer_cash_in()
		
	update_ui()

func computer_choice() -> Vector2i:
	var best_column = -1 # Index of best column
	var best_score = -10000.0 #Score of best column
	
	#Dice details
	var face = current_dice.get_face_value() 
	var score = current_dice.get_score_value()
	
	# 10% chance to make a random move
	if randf() < 0.1:
		var valid_cols = []
		
		for i in range(3):
			if not is_column_full(player2_dice_grid, i):
				valid_cols.append(i)
		if valid_cols.size() > 0:
			var random_col = valid_cols.pick_random()
			return Vector2i(random_col, 0) 

	# Evaluate each column and find the best choice
	for col in range(3):
		var column_score = computer_evaluate_col(col, face, score)
		column_score += randf() * 2.0 # Acts as a tie breaker between columns
				
		if column_score > best_score:
			best_score = column_score
			best_column = col
			
	#If no valid moves.
	if best_column == -1: 
		best_column = 0

	return Vector2i(best_column, 0)

func should_computer_cash_in() -> bool:
	var computer_score = player2_dice_grid.get_grid_score() #Get own grid score
	
	if computer_score <= 0: 
		return false # Cannot cash in anything if score is 0
	
	if computer_score >= player1_health:
		# Cash in to win the game.
		computer_thoughts.text = "Computer sees a win..."
		await get_tree().create_timer(0.5).timeout
		return true
		
	if player2_health < 30 and computer_score > 15:
		# If own health is less, try to get even with other player.
		computer_thoughts.text = "Computer is playing defensively."
		await get_tree().create_timer(0.5).timeout
		return true
		
	if computer_score > 40 and randf() < 0.75:
		# A 75% chance to secure points
		computer_thoughts.text = "Computer is securing points."
		await get_tree().create_timer(0.5).timeout
		return true

	return false

func should_computer_reroll() -> bool:
	if not player2_can_reroll: 
		# If do not have the ability to re-roll.
		return false
	
	var val = current_dice.score_value 
	
	if val >= 4: 
		# Do not re roll if you have a good value dice
		return false
	

	for col_idx in range(3):
		var my_col = get_column_content(player2_dice_grid, col_idx)
		for die in my_col:
			# If there is a matching dice in any of my column do not re-roll
			if die != null and die.score_value == val:
				return false 
		
		var opp_col = get_column_content(player1_dice_grid, col_idx)
		for die in opp_col:
			# Using the original concept for destroying the dice -> If opponent has a matching dice do not re-roll
			if die != null and die.score_value == val:
				return false 
	return true

func should_computer_skip_turn() -> bool:
	var face = current_dice.get_face_value()
	var score = current_dice.get_score_value()
	
	# Never skip a 2 (Dice 2 effect is too good)
	if face == 2:
		return false
		
	# Dice 1 Effect Consideration
	if face == 1:
		# If if computer's health is low. Do not skip
		if player2_health < 40:
			return false
		# Otherwise, a 1 is a low score, so we might want to skip it
		return true 
		
	# If any bad score (Considering Dice 6 Effect)
	if score < 2:
		return true
		
	return false

func computer_skip_turn():
	computer_thoughts.text = "Computer Skipped!"
	await get_tree().create_timer(0.6).timeout
	skip_turn()
	

func computer_cash_in() -> void:
	computer_thoughts.text = "Computer Cashed In!"
	await get_tree().create_timer(0.6).timeout
	perform_cash_in()

# AI Helper Functions

#Get all the dice for a specific column
func get_column_content(grid: DiceGrid, col_index: int) -> Array:
	var content = []
	for row in range(3):
		var tile_index = col_index + (row * 3) #1 Dimenional Tile index = column + row x 3
		var tile = grid.get_child(tile_index) # Assuming tiles are children in order
		if is_instance_valid(tile.dice):
			content.append(tile.dice)
		else:
			content.append(null)
	return content
	

func is_column_full(grid: DiceGrid, col_index: int) -> bool:
	var content = get_column_content(grid, col_index)

	for item in content:
		if item == null: 
			return false
	return true

func computer_evaluate_col (col_index: int, dice_face_value: int, dice_score_value: int) -> float:
	var column_score: float = 0.0 
	
	if is_column_full(player2_dice_grid, col_index):
		return -1000.0; # Worst column -> No valid moves
		
	var ai_columns = get_column_content(player2_dice_grid,col_index);
	var human_column = get_column_content(player1_dice_grid,col_index);
	
	column_score += dice_face_value # Add the value to the score
	
	#If there are same dice in this column add score
	for die in ai_columns:
		if die != null and die.get_face_value() == dice_face_value:
			column_score += (dice_score_value * 2)
	
	# Dice 4 Effect Consideration -> If the opponent's column is valuable highly consider placing it here
	if dice_face_value == 4:
		for die in human_column:
			if die != null:
				column_score += die.get_score_value() * 1.2
	
	# Dice 2 Effect Consideration	
	var existing_column_has_two: bool = false
	var existing_column_score_sum: int = 0
	
	# Find if the column has two
	for die in ai_columns:
		if die != null:
			existing_column_score_sum += die.get_score_value()
			if die.get_face_value() == 2:
				existing_column_has_two = true
				
	# If the current dice is 2, Assign score to the column according to it's total value to get the most valuable multiplier
	if dice_face_value == 2:
		column_score += existing_column_score_sum * 1.2 
		if existing_column_has_two:
			column_score += 15.0 # Extra bonus for stacking multipliers
	elif existing_column_has_two:
		# If the column has two but the current dice is not two -> Need to place the current dice according to its value
		column_score += dice_score_value * 1.5 # Weigh high-value dice heavily here
		
	# Dice 1 Effect  Consideration -  Only valuable if computer health is low.
	if dice_face_value == 1:
		var missing_health = MAX_HEALTH - player2_health
		if missing_health > 0:
			column_score += missing_health * 0.5 
	
	# Note -> Not considering Dice Effect 6 for column consideration as it can be placed anywhere and work well
	# Will only consider it for skip and re-roll

	return column_score



func remove_opponent_dice(tile_index: Vector2i):
	var current_board: DiceGrid = player2_dice_grid if player_turn == 1 else player1_dice_grid
	
	tile_index.x = flip_horizontally(tile_index.x)
	var tile: DiceTile = current_board.get_tile(tile_index)
	var tile_dice = tile.dice
	
	if is_instance_valid(tile_dice):
		audio_manager.destroy_sfx.play()
		tile_dice.destroy()
		update_ui()
	
	update_ui()


func flip_horizontally(column: int) -> int:
	if column == 0:
		column = 2
	elif column == 2:
		column = 0
	
	return column


func switch_turn() -> void:
	if player_turn == 1:
		player_turn = 2
		player2_turn()
	else:
		player_turn = 1
		player1_turn()


func check_game_over(new_health: int, player_number: int) -> void:
	if new_health <= 0:
		game_over = true
		var winning_player: String = "1" if player_number == 2 else "2"
		GameManager.winner_text = "Player {0} Wins!".format([winning_player])
		SceneManager.change_scene("res://scenes/game_over.tscn")



func get_random_tile() -> Vector2i:
	var random_tile_index := Vector2i.ZERO
	random_tile_index.x = randi() % 3
	random_tile_index.y = randi() % 3
	
	var tile: DiceTile = player2_dice_grid.get_tile(random_tile_index)
	if not tile.dice == null:
		random_tile_index = get_random_tile()
	
	return random_tile_index


# TODO: Add UI management into its own node/script
# I think there's a way to automatically call a function when certain values are changed, so
# TODO: Call function automatically when certain values are changed
func update_ui() -> void:
	var player1_score: int = player1_dice_grid.get_grid_score()
	var player2_score: int = player2_dice_grid.get_grid_score()
	
	player1_score_label.text = "P1 Score: " + str(player1_score) 
	player2_score_label.text = "P2 Score: " + str(player2_score)
	
	if current_dice == null:
		turn_indicator_label.text = (
				"Player 1's Turn: Roll the dice!" if player_turn == 1 
				else "Player 2's Turn: Roll the dice!"
		)
	
	else:
		var current_roll: int = current_dice.get_face_value()
		turn_indicator_label.text = (
				"Player 1 Rolled: " + str(current_roll) if player_turn == 1 
				else "Player 2 Rolled: " + str(current_roll)
		)
	computer_thoughts.text = ""


#Health bar system code:


func perform_cash_in() -> void:
	
	if not current_dice == null:
		return
	
	var current_player_grid: DiceGrid = player1_dice_grid if player_turn == 1 else player2_dice_grid
	var score_to_cash_in: int = current_player_grid.get_grid_score()
	
	if score_to_cash_in > 0:
		if player_turn == 1:
			player2_health -= score_to_cash_in
		else:
			player1_health -= score_to_cash_in
	else:
		return
	
	if game_over:
		return
	
	audio_manager.attack_sfx.play()
	
	var current_grid: DiceGrid = player1_dice_grid if player_turn == 1 else player2_dice_grid
	current_grid.clear()
	
	switch_turn()
	
	update_ui()


func _on_player_1_cash_in_button_pressed() -> void:
	if player_turn == 1:
		perform_cash_in()


func _on_player_2_cash_in_button_pressed() -> void:
	if player_turn == 2:
		perform_cash_in()


func health_change_animation(new_health: int, old_health: int, player_number: int) -> void:
	if new_health == old_health:
		return
	
	var health_bar: ProgressBar = player1_healthbar if player_number == 1 else player2_healthbar
	var tween: Tween = create_tween()
	
	if new_health < old_health:
		tween.tween_property(health_bar,"self_modulate",Color.RED, 0.2)
	else:
		tween.tween_property(health_bar,"self_modulate",Color.GREEN, 0.2)
		audio_manager.heal_sfx.play()
	
	tween.tween_property(health_bar,"self_modulate",Color.WHITE, 0.2)


func dice_1_effect() -> void:
	var current_player_health: int = player1_health if player_turn == 1 else player2_health
	
	if current_player_health >= 100:
		return
	
	if player_turn == 1:
		player1_health += 1
	else:
		player2_health += 1


# Debug Functions

func print_player_grids() -> void:
	print("\nP1 Grid:")
	player1_dice_grid.print_tiles()
	
	print("\nP2Grid:")
	player2_dice_grid.print_tiles()
	
	print("\n")


# Skip Turn	

func skip_turn() -> void:
	if game_over:
		return
	
	# Only give ability to skip if the player has alteast rolled something
	if current_dice == null:
		return
	# Clear up the current rolled number and update turn and switch turns
	audio_manager.skip_sfx.play()
	current_dice.destroy()
	current_dice = null
	update_ui()
	switch_turn()


func _on_player_1_skip_turn_button_pressed() -> void:
	skip_turn()
	player1_skip_button.disabled = true


func _on_player_2_skip_turn_button_pressed() -> void:
	skip_turn()
	player2_skip_button.disabled = true


func perform_reroll() -> void:
	if game_over: 
		return
	
	if current_dice == null: 
		return # Can't reroll if we haven't rolled yet
	
	current_dice.destroy()
	current_dice = null
	
	turn_indicator_label.text = "Player Re-Rolled!"
	#await get_tree().create_timer(0.5).timeout
	
	# Can't reroll more than once
	if player_turn == 1:
		player1_can_reroll = false
	else:
		player2_can_reroll = false
	
	# Roll a new dice
	roll_dice()


# Connect these to your buttons in the Node tab!

func _on_player_1_re_roll_button_pressed() -> void:
	perform_reroll()
	player1_reroll_button.visible = false
	player1_roll_button.visible = true


func _on_player_2_re_roll_button_pressed() -> void:
	perform_reroll()
	player2_reroll_button.visible = false
	player2_roll_button.visible = true
