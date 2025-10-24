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


func _ready() -> void:
	player1_dice_grid.on_tile_selected.connect(place_dice)
	player2_dice_grid.on_tile_selected.connect(place_dice)
	
	player1_roll_button.visible = false
	player2_roll_button.visible = false
	
	if GameManager.playerNumber == 1:
		is_player2_human = false
	else:
		is_player2_human = true
	
	if player_turn == 1:
		player1_turn()
	else:
		player2_turn()


func player1_turn() -> void:
	player1_roll_button.disabled = false
	player1_roll_button.visible = true
	player2_roll_button.visible = false
	update_ui()


func player2_turn() -> void:
	if is_player2_human:
		player2_roll_button.disabled = false
		player2_roll_button.visible = true
		player1_roll_button.visible = false
		update_ui()
	else:
		computer_turn()


func _on_roll_button_pressed() -> void:
	if game_over:
		return
	
	roll_dice()
	update_ui()
	
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
	
	player1_dice_grid.disable_tiles()
	tile.dice = current_dice
	current_dice = null
	switch_turn()


func computer_turn() -> void:
	if game_over: 
		return
	# disable player roll button
	player1_roll_button.disabled = true
	player1_roll_button.visible = false
	await get_tree().create_timer(.8).timeout  # delay before roll
	roll_dice()
	update_ui()
	await get_tree().create_timer(1.2).timeout  # delay before placing dice
	var choice: Vector2i = computer_choice() #Then get the best choice
	var tile: DiceTile = player2_dice_grid.get_tile(choice)
	place_dice(tile)


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
	var player1_full: bool = true
	for i in player1_rows:
		if 0 in i:
			player1_full = false
	
	var player2_full: bool = true
	for i in player2_rows:
		if 0 in i:
			player2_full = false
	
	if player1_full or player2_full:
		var player1_scores: int = (
				calculate_row_score(player1_rows[0]) 
				+ calculate_row_score(player1_rows[1]) 
				+ calculate_row_score(player1_rows[2])
		)
		
		var player2_scores: int = (
				calculate_row_score(player2_rows[0]) 
				+ calculate_row_score(player2_rows[1]) 
				+ calculate_row_score(player2_rows[2])
		)
		
		if player1_scores > player2_scores:
			GameManager.winner_text = "Player 1 Wins";
		elif player1_scores < player2_scores:
			GameManager.winner_text = "Player 2 Wins";
		else:
			GameManager.winner_text = "It's a draw!"
		game_over = true
		SceneManager.change_scene("res://scenes/game_over.tscn")


func computer_choice():
	var row_scores = [0,0,0] #Scores to figure out the best column
	var rows = [player2_rows[0], player2_rows[1], player2_rows[2]] #Get the value of the columns
	var opponet_rows = [player1_rows[0], player1_rows[1], player1_rows[2]] #Opponent column to figure out the best move
	 
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
func update_ui():
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
		turn_indicator_label.text = "Player 1's Turn: Roll the dice!" if player_turn == 1 else "Player 2's Turn: Roll the dice!"
	else:
		var current_roll: int = current_dice.get_score_value()
		turn_indicator_label.text = "Player 1 Rolled: " + str(current_roll) if player_turn == 1 else "Player 2 Rolled: " + str(current_roll)


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
