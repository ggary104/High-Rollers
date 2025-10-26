# scripts/Game.gd
extends Node2D

#Variables - To store the main game logic data
var DiceObject := preload("res://scenes/dice.tscn")
var player_turn: int = randi() % 2  + 1 #Is it player1's turn or player 2s

var player1_rows: Array = [
	[0, 0, 0], 
	[0, 0, 0], 
	[0, 0, 0],
	] 

var player2_rows: Array = [
	[0, 0, 0],
	[0, 0, 0], 
	[0, 0, 0], 
	]

var is_player2_human: bool = false
var game_over: bool = false 
var dice_textures: Array = []
var current_dice: Dice = null

const MAX_HEALTH: int = 100
var player1_health: int = MAX_HEALTH
var player2_health: int = MAX_HEALTH

# Variables used in labels to display the scores and Which Players Turn Is It
# On ready -> They need to load when the labels are loaded 
@onready var player1_score_label = $"UI-Elements/Player1Score" as Label
@onready var player2_score_label = $"UI-Elements/Player2Score" as Label
@onready var player1_roll_button = $"UI-Elements/Player1RollButton" as Button
@onready var player2_roll_button = $"UI-Elements/Player2RollButton" as Button
@onready var turn_indicator_label = $"UI-Elements/TurnIndicator" as Label
@onready var player1_dice_grid = $Board/DiceGrid as DiceGrid
@onready var player2_dice_grid = $Board/DiceGrid2 as DiceGrid
@onready var dice_spawn_position = $Board/DiceSpawnPosition as Marker2D

#Variable for player 1 and player 2 cash in button used for attacking the health
@onready var player1_cash_in_button = $"UI-Elements/Player1CashInButton" as Button
@onready var player2_cash_in_button = $"UI-Elements/Player2CashInButton" as Button
@onready var player1_healthbar = $"UI-Elements/Player1Health" as ProgressBar
@onready var player2_healthbar = $"UI-Elements/Player2Health" as ProgressBar


func _ready() -> void:
	player1_dice_grid.on_tile_selected.connect(place_dice)
	player2_dice_grid.on_tile_selected.connect(place_dice)

	player1_roll_button.visible = false
	player2_roll_button.visible = false
	player1_cash_in_button.visible = false
	player2_cash_in_button.visible = false
	
	if GameManager.playerNumber == 1:
		is_player2_human = false
	else:
		is_player2_human = true
	
	if player_turn == 1:
		player1_turn()
	else:
		player2_turn()
	update_health_bars()


func player1_turn() -> void:
	player1_roll_button.disabled = false
	player1_roll_button.visible = true
	player2_roll_button.visible = false
	
	player1_cash_in_button.visible = true
	player1_cash_in_button.disabled = false
	player2_cash_in_button.visible = false
	
	update_ui()


func player2_turn() -> void:
	update_ui()
	player1_roll_button.disabled = true
	player1_roll_button.visible = false
	
	if is_player2_human:
		player2_roll_button.disabled = false
		player2_roll_button.visible = true
		player1_roll_button.visible = false
		
		player2_cash_in_button.visible = true
		player2_cash_in_button.disabled = false
		player1_cash_in_button.visible = false
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
	else:
		player2_roll_button.disabled = true


func roll_dice() -> void:
	var current_roll: int = randi() % 6 + 1;
	var dice: Dice = DiceObject.instantiate()
	add_child(dice)
	dice.set_score_value(current_roll)
	dice.position = dice_spawn_position.position
	current_dice = dice
	
	if player_turn == 1:
		player1_dice_grid.enable_tiles()
	elif player_turn == 2 and is_player2_human:
		player2_dice_grid.enable_tiles()
	
	update_ui()


func place_dice(tile: DiceTile) -> void:
	var current_player_rows: Array = player1_rows if player_turn == 1 else player2_rows
	var tile_index: Vector2i = tile.index
	
	if current_player_rows[tile_index.y][tile_index.x] != 0:
		return
	
	var tile_position: Vector2 = tile.global_position
	current_dice.position = tile_position
	
	var dice_value: int = current_dice.get_score_value()
	current_player_rows[tile_index.y][tile_index.x] = dice_value
	print_player_grids()
	
	remove_opponent_dice(tile_index.y, dice_value)
	
	var current_dice_grid: DiceGrid = player1_dice_grid if player_turn == 1 else player2_dice_grid
	if current_dice_grid.is_enabled:
		current_dice_grid.disable_tiles()
	
	tile.dice = current_dice
	current_dice = null
	switch_turn()


func computer_turn() -> void:
	if game_over: 
		return
	# disable player roll button
	
	var player2_score: int = (
			calculate_row_score(player2_rows[0]) 
			+ calculate_row_score(player2_rows[1]) 
			+ calculate_row_score(player2_rows[2])
	)
	
	var is_current_grid_full: bool = player2_dice_grid.is_full()
	if is_current_grid_full:
		await computer_cash_in()
	
	var cash_in_chance: float = 0.3
	
	if player2_score > 0 and randf() < cash_in_chance:
		await computer_cash_in()
	else:
		await get_tree().create_timer(.8).timeout  # delay before roll
		roll_dice()
		await get_tree().create_timer(1.2).timeout  # delay before placing dice
		var choice: Vector2i = computer_choice() #Then get the best choice
		var tile: DiceTile = player2_dice_grid.get_tile(choice)
		place_dice(tile)
	
	update_ui()


func computer_cash_in() -> void:
	turn_indicator_label.text = "Computer Cashed In!"
	await get_tree().create_timer(1.2).timeout
	perform_cash_in()


func remove_opponent_dice(row_index: int, roll_value: int):
	var opponent_rows: Array = player2_rows if player_turn == 1 else player1_rows
	var current_board: DiceGrid = player2_dice_grid if player_turn == 1 else player1_dice_grid
	var column: int = 0
	
	for value in opponent_rows[row_index]:
		print(row_index)
		print(column)
		if value == roll_value:
			print("destroy")
			opponent_rows[row_index][column] = 0
			print_player_grids()
			var destroyed_dice_index := Vector2i(column, row_index)
			var tile: DiceTile = current_board.get_tile(destroyed_dice_index)
			print(tile.index)
			var dice: Dice = tile.dice
			print(dice)
			# TODO: Make dice send a signal to tile that sets the tile's dice property to null
			dice.destroy()
			tile.dice = null
		
		column += 1
	
	update_ui()


func calculate_row_score(row: Array) -> int:
	var score: int = 0
	var counts := {}
	
	for die_value in row:
		#Get the number of times a digit ocurred
		if die_value > 0:
			if not counts.has(die_value):
				counts[die_value] = 0
			counts[die_value] += 1
			
	for die_value in counts:
		#Calculate the score based on the frequency
		var num_of_dice: int = counts[die_value]
		score += num_of_dice * die_value * num_of_dice
	
	return score


func switch_turn() -> void:
	check_game_over()
	if player_turn == 1:
		player_turn = 2
		player2_turn()
	else:
		player_turn = 1
		player1_turn()


func check_game_over() -> void:
	if player1_health <= 0:
		game_over = true
		GameManager.winner_text = "Player 2 Wins!"
		SceneManager.change_scene("res://scenes/game_over.tscn")
	elif player2_health <= 0:
		game_over = true
		GameManager.winner_text = "Player 1 Wins!"
		SceneManager.change_scene("res://scenes/game_over.tscn")
	
	
	# KEEPING THIS COMMENTED FOR REFERENCE FOR THE 'CLASSIC' MODE IF NEEDED
	#var player1_full: bool = true
	#for i in player1_rows:
		#if 0 in i:
			#player1_full = false
	#
	#var player2_full: bool = true
	#for i in player2_rows:
		#if 0 in i:
			#player2_full = false
	#
	#if player1_full or player2_full:
		#var player1_scores: int = (
				#calculate_row_score(player1_rows[0]) 
				#+ calculate_row_score(player1_rows[1]) 
				#+ calculate_row_score(player1_rows[2])
		#)
		#
		#var player2_scores: int = (
				#calculate_row_score(player2_rows[0]) 
				#+ calculate_row_score(player2_rows[1]) 
				#+ calculate_row_score(player2_rows[2])
		#)
		#
		#if player1_scores > player2_scores:
			#GameManager.winner_text = "Player 1 Wins";
		#elif player1_scores < player2_scores:
			#GameManager.winner_text = "Player 2 Wins";
		#else:
			#GameManager.winner_text = "It's a draw!"


func computer_choice() -> Vector2i:
	#var row_scores = [0,0,0] #Scores to figure out the best column
	#var rows = [player2_rows[0], player2_rows[1], player2_rows[2]] #Get the value of the columns
	#Opponent column to figure out the best move
	#var opponet_rows = [player1_rows[0], player1_rows[1], player1_rows[2]] 
	 
	var random_move: Vector2i = get_random_tile()
	return random_move
	
	#for i in range(3):
		#if rows[i][2] != 0:
			##If the column is filled no need to use it -> Lowest score
			#row_scores[i] = -100
			#continue
		#
		#for die in rows[i]:
			##For Double Score
			#if die == current_roll:
				#row_scores[i] += 10
		#
		#for die in opponet_rows[i]:
			##For destroying opponent dice
			#if die == current_roll:
				#row_scores[i] += 4
		#
		#for die in rows[i]:
			##Column has free space
			#if die == 0:
				#row_scores[i] += 1;
	#var best_score  = -101;
	#var best_row = 0
	#for i in range(3):
		#if row_scores[i] > best_score:
			#best_row = i
			#best_score = row_scores[i]
	#return best_row


func get_random_tile() -> Vector2i:
	var random_tile_index := Vector2i.ZERO
	random_tile_index.x = randi() % 3
	random_tile_index.y = randi() % 3
	
	if player2_rows[random_tile_index.y][random_tile_index.x] != 0:
		random_tile_index = get_random_tile()
	
	return random_tile_index


# TODO: Put score calculation into its own function
# TODO: Add UI management into its own node/script
# I think there's a way to automatically call a function when certain values are changed, so
# TODO: Call function automatically when certain values are changed
func update_ui() -> void:
	var player1_score: int = (
			calculate_row_score(player1_rows[0]) 
			+ calculate_row_score(player1_rows[1]) 
			+ calculate_row_score(player1_rows[2])
	)
	
	var player2_score: int = (
			calculate_row_score(player2_rows[0]) 
			+ calculate_row_score(player2_rows[1]) 
			+ calculate_row_score(player2_rows[2])
	)
	
	player1_score_label.text = "P1 Score: " + str(player1_score) 
	player2_score_label.text = "P2 Score: " + str(player2_score)
	
	if current_dice == null:
		turn_indicator_label.text = (
				"Player 1's Turn: Roll the dice!" if player_turn == 1 
				else "Player 2's Turn: Roll the dice!"
		)
	else:
		var current_roll: int = current_dice.get_score_value()
		turn_indicator_label.text = (
				"Player 1 Rolled: " + str(current_roll) if player_turn == 1 
				else "Player 2 Rolled: " + str(current_roll)
		)


#Health bar system code:
func update_health_bars() -> void:
	player1_healthbar.value = player1_health
	player2_healthbar.value = player2_health


func perform_cash_in() -> void:
	if game_over:
		return
	
	if not current_dice == null:
		return
	
	var current_player_rows: Array = player1_rows if player_turn == 1 else player2_rows
	var score_to_cash_in: int = (
			calculate_row_score(current_player_rows[0]) 
			+ calculate_row_score(current_player_rows[1]) 
			+ calculate_row_score(current_player_rows[2])
	)
	
	if score_to_cash_in > 0:
		if player_turn == 1:
			player2_health -= score_to_cash_in
		else:
			player1_health -= score_to_cash_in
	else:
		return
	
	player1_health = max(0,player1_health)
	player2_health = max(0,player2_health)
	health_damage_animation()
	update_health_bars();
	
	for i in range(3):
		for j in range(3):
			current_player_rows[i][j] = 0
	
	var current_grid: DiceGrid = player1_dice_grid if player_turn == 1 else player2_dice_grid
	current_grid.clear()
	check_game_over()
	
	if !game_over:
		switch_turn()
	
	update_ui()


func _on_player_1_cash_in_button_pressed() -> void:
	if player_turn == 1:
		perform_cash_in()


func _on_player_2_cash_in_button_pressed() -> void:
	if player_turn == 2:
		perform_cash_in()


func health_damage_animation():
	var health_bar = player1_healthbar if player_turn == 2 else player2_healthbar
	
	var tween := create_tween();
	tween.tween_property(health_bar,"self_modulate",Color.RED, 0.2)
	tween.tween_property(health_bar,"self_modulate",Color.WHITE, 0.2)


# Debug Functions

func print_player_grids() -> void:
	print("\nP1 Grid:")
	print(player1_rows[0])
	print(player1_rows[1])
	print(player1_rows[2])
	
	print("\nP2Grid:")
	print(player2_rows[0])
	print(player2_rows[1])
	print(player2_rows[2])
	
	print("\n")
