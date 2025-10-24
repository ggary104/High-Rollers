# scripts/Game.gd
extends Node2D

#Variables - To store the main game logic data
var Dice:PackedScene = preload("res://scenes/dice.tscn")
var player_turn: int = randi() % 2  + 1 #Is it player1's turn or player 2s
var current_roll: int = 0 
var p1_rows: Array = [
	[0, 0, 0], 
	[0, 0, 0], 
	[0, 0, 0],
	] 

var p2_rows:Array = [
	[0, 0, 0],
	[0, 0, 0], 
	[0, 0, 0], 
	]

var game_over:bool = false 
var dice_textures:Array = []
var current_dice:Node2D = null
var current_rows:Array = []

# Variables used in labels to display the scores and Which Players Turn Is It
# On ready -> They need to load when the labels are loaded 
@onready var p1_score_label = $"UI-Elements/Player1Score"
@onready var p2_score_label = $"UI-Elements/Player2Score"
@onready var turn_indicator_label = $"UI-Elements/TurnIndicator"
@onready var player1_roll = $"UI-Elements/Player1Roll"
@onready var player2_roll = $"UI-Elements/Player2Roll"
@onready var p1_dice_grid = $Board/DiceGrid
@onready var p2_dice_grid = $Board/DiceGrid2
@onready var Marker = $Marker2D
@onready var Marker2 = $Marker2D2


func _ready() -> void:
	p1_dice_grid.on_tile_selected.connect(place_dice)
	p2_dice_grid.on_tile_selected.connect(place_dice)
	
	$"UI-Elements/Player1RollButton".visible = false
	$"UI-Elements/Player2RollButton".visible = false
	
	if player_turn == 1:
		player_one_turn()
	else:
		player_two_turn()


func player_one_turn() -> void:
	p2_dice_grid.disable_tiles()
	$"UI-Elements/Player1RollButton".disabled = false
	$"UI-Elements/Player1RollButton".visible = true
	$"UI-Elements/Player2RollButton".visible = false
	update_ui()


func player_two_turn() -> void:
	if(GameManager.playerNumber == 1):
		#Computer's turns if the player number is 1
		computer_turn()
	else:
		$"UI-Elements/Player2RollButton".disabled = false
		$"UI-Elements/Player2RollButton".visible = true
		$"UI-Elements/Player1RollButton".visible = false
		update_ui()


func _on_roll_button_pressed() -> void:
	if game_over:
		return
	
	roll_dice()
	update_ui()
	
	if player_turn == 1:
		$"UI-Elements/Player1RollButton".disabled = true
	else:
		$"UI-Elements/Player2RollButton".disabled = true


func roll_dice() -> void:
	current_roll = randi() % 6 + 1;
	var dice = Dice.instantiate()
	add_child(dice)
	dice.set_score_value(current_roll)
	dice.position = Marker.position
	current_dice = dice
	if player_turn == 1:
		p1_dice_grid.enable_tiles()
	else:
		p2_dice_grid.enable_tiles()


func place_dice(tile) -> void:
	var current_player_rows = p1_rows if player_turn == 1 else p2_rows
	var tile_index = tile.index
	if current_player_rows[tile_index.y-1][tile_index.x-1] != 0:
		return
	
	var tile_position = tile.global_position
	current_dice.position = tile_position
	
	var column_number = tile_index.x
	var row_number = tile_index.y
	var dice_value = current_dice.get_score_value()
	current_player_rows[row_number-1][column_number-1] = dice_value
	print_board(current_player_rows)
	
	remove_opponent_dice(row_number, dice_value)
	
	p1_dice_grid.disable_tiles()
	tile.dice = current_dice
	print(tile.dice)
	current_dice = null
	switch_turn()


func computer_turn():
	if(game_over): return
	# disable player roll button
	$"UI-Elements/Player1RollButton".disabled = true
	$"UI-Elements/Player1RollButton".visible = false
	roll_dice() #First generate random number
	await get_tree().create_timer(.8).timeout  # delay before roll
	update_ui()
	await get_tree().create_timer(1.2).timeout  # delay before placing dice
	var choice = computer_choice() #Then get the best choice
	computer_move(choice)


func computer_move(computer_pick) -> void:
	var dice_number = computer_pick.x + (computer_pick.y - 1) * 3
	var tile = p2_dice_grid.get_tile(dice_number)
	place_dice(tile)


func remove_opponent_dice(row_index, roll_value):
	
	var opponent_rows = p2_rows if player_turn == 1 else p1_rows
	var current_board = p2_dice_grid if player_turn == 1 else p1_dice_grid
	var column = 1
	
	for value in opponent_rows[row_index-1]:
		print(row_index)
		print(column)
		if value == roll_value:
			print("destroy")
			opponent_rows[row_index-1][column-1] = 0
			print_board(opponent_rows)
			var dice_number = column + (row_index - 1) * 3
			var tile = current_board.get_tile(dice_number)
			print(tile.index)
			var dice = tile.dice
			print(dice)
			dice.destroy()
			tile.dice = null
		
		column += 1
	
	#for i in opponent_rows[row_index]:
		##Get everything other than what the other player pulled
		#print(i)
		#if i != roll_value:
			#new_col.append(i)
		##Fill with zero to complete 
	#while new_col.size() < 3:
		#new_col.append(0)
	#
	#opponent_rows[row_index] = new_col


func calculate_column_score(column):
	var score = 0
	var counts = {}
	
	for die_value in column:
		#Get the number of times a digit ocurred
		if die_value > 0:
			if not counts.has(die_value):
				counts[die_value] = 0
			counts[die_value] += 1
			
	for die_value in counts:
		#Calculate the score based on the frequency
		var num_of_dice = counts[die_value]
		score += num_of_dice * die_value * num_of_dice
	
	return score


func switch_turn():
	check_game_over()
	if(player_turn == 1):
		player_turn = 2
	else	:
		player_turn = 1
	current_roll = 0
	update_ui() 
	# start next turn	
	if player_turn == 1:
		player_one_turn()
	else:
		player_two_turn()


func check_game_over():
	var p1_full = true
	for i in p1_rows:
		if 0 in i:
			p1_full = false
	
	var p2_full = true
	for i in p2_rows:
		if 0 in i:
			p2_full = false
	
	if p1_full or p2_full:
		var p1_scores = calculate_column_score(p1_rows[0]) + calculate_column_score(p1_rows[1]) + calculate_column_score(p1_rows[2])
		var p2_scores = calculate_column_score(p2_rows[0]) + calculate_column_score(p2_rows[1]) + calculate_column_score(p2_rows[2])
		
		if p1_scores > p2_scores:
			GameManager.winner_text = "Player 1 Wins";
		elif p1_scores < p2_scores:
			GameManager.winner_text = "Player 2 Wins";
		else:
			GameManager.winner_text = "It's a draw!"
		game_over = true
		SceneManager.change_scene("res://scenes/game_over.tscn")


func computer_choice():
	var row_scores = [0,0,0] #Scores to figure out the best column
	var rows = [p2_rows[0], p2_rows[1], p2_rows[2]] #Get the value of the columns
	var opponet_rows = [p1_rows[0], p1_rows[1], p1_rows[2]] #Opponent column to figure out the best move
	 
	var randice = get_random_tile()
	return randice
	
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


func get_random_tile() -> Vector2:
	var randice = Vector2.ZERO
	randice.x = randi() % 3 + 1
	randice.y = randi() % 3 + 1
	
	if p2_rows[randice.y-1][randice.x-1] != 0:
		print("reroll")
		randice = get_random_tile()
	
	return randice


func update_ui():
	var p1_score = calculate_column_score(p1_rows[0]) + calculate_column_score(p1_rows[1]) + calculate_column_score(p1_rows[2])
	var p2_score = calculate_column_score(p2_rows[0]) + calculate_column_score(p2_rows[1]) + calculate_column_score(p2_rows[2])
	
	p1_score_label.text = "P1 Score: " + str(p1_score) #Change the latest scores
	p2_score_label.text = "P2 Score: " + str(p2_score)
	
	
	#Display the current player's turn
	if current_roll == 0:
		turn_indicator_label.text = "Player 1's Turn: Roll the dice!" if player_turn == 1 else "Player 2's Turn: Roll the dice!"
	else:
		turn_indicator_label.text = "Player 1 Rolled: " + str(current_roll) if player_turn == 1 else "Player 2 Rolled: " + str(current_roll)


# Debug Functions

func print_board(player_board) -> void:
	print(player_board[0])
	print(player_board[1])
	print(player_board[2])
