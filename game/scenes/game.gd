# scripts/Game.gd
extends Node2D

#Variables - To store the main game logic data
const MAX_HEALTH = 100
var p1_health = MAX_HEALTH
var p2_health = MAX_HEALTH
var DiceSlotScene = preload("res://scenes/die_slot.tscn")
var player_turn = randi() % 2  + 1 #Is it player1's turn or player 2s
var current_roll = 0 #Value of the current roll
var p1_cols = [[0, 0, 0], [0, 0, 0], [0, 0, 0]] #What is the state of the player1's column
var p2_cols = [[0, 0, 0], [0, 0, 0], [0, 0, 0] ]#What is the state of the player2's column
var game_over = false 
var dice_textures = []

#Variables used in labels to display the scores and Which Players Turn Is It
#On ready -> They need to load when the labels are loaded 
@onready var player1_column_inputs = $"Board/Player1Board/Player1ColumnInputs"
@onready var player2_column_inputs = $"Board/Player2Board/Player2ColumnInputs"
@onready var p1_grid = $Board/Player1Board/Player1Grid
@onready var p2_grid = $Board/Player2Board/Player2Grid
@onready var p1_score_label = $"UI-Elements/Player1Score"
@onready var p2_score_label = $"UI-Elements/Player2Score"
@onready var turn_indicator_label = $"UI-Elements/TurnIndicator"
@onready var player1_roll = $"UI-Elements/Player1Roll"
@onready var player2_roll = $"UI-Elements/Player2Roll"
@onready var p1_cash_in_button = $"UI-Elements/Player1CashInButton"
@onready var p2_cash_in_button = $"UI-Elements/Player2CashInButton"


func _ready():
	#Load all of the die images
	for i in range(1, 7):
		var texture = load("res://assests/dice_" + str(i) + ".svg")
		dice_textures.append(texture)
	
	#In the grid have Empty DiceSlotScene to have the grid remain constant size
	for i in range(9):
		p1_grid.add_child(DiceSlotScene.instantiate())
		p2_grid.add_child(DiceSlotScene.instantiate())
	
	# Start with roll buttons invisble
	$"UI-Elements/Player1RollButton".visible = false
	$"UI-Elements/Player2RollButton".visible = false
	
	if player_turn == 1:
		player_one_turn()
	else:
		player_two_turn()
	update_health_bars()

func player_one_turn():
		for button in player1_column_inputs.get_children():
			button.disabled = false
		for button in player2_column_inputs.get_children():
			button.disabled = true
		$"UI-Elements/Player1RollButton".disabled = false
		$"UI-Elements/Player1RollButton".visible = true
		$"UI-Elements/Player2RollButton".visible = false
		p1_cash_in_button.visible = true
		p1_cash_in_button.disabled = false
		p2_cash_in_button.visible = false
		update_ui()

func player_two_turn():
	if(GameManager.playerNumber == 1):
		#Computer's turns if the player number is 1
		for button in player1_column_inputs.get_children():
			if button is Button:
				button.disabled = true
		computer_turn()
	else:
		for button in player2_column_inputs.get_children():
			button.disabled = false
		for button in player1_column_inputs.get_children():
			button.disabled = true
		$"UI-Elements/Player2RollButton".disabled = false
		$"UI-Elements/Player2RollButton".visible = true
		$"UI-Elements/Player1RollButton".visible = false
		p2_cash_in_button.visible = true
		p2_cash_in_button.disabled = false
		p1_cash_in_button.visible = false
		update_ui()

func roll_dice():
	current_roll = randi() % 6 + 1; # Get a random integer and get the remainder from dividing by 6 to get 0-5 remainder and add 1 to make it 1-6

func place_dice(column_index):
	if current_roll == 0:
		return
	#Get the columns for the currect player
	var current_player_cols = p1_cols if player_turn == 1 else p2_cols
	
	for i in range (3):
			#Check if the nearest column value is zero
		if current_player_cols[column_index][i] == 0:
			current_player_cols[column_index][i] = current_roll
			#If the dice value are same then remove opponet dice
			remove_opponent_dice(column_index,current_roll)
			#update the visuals and switch the turns
			update_board_visuals()
			switch_turn()
			return

func remove_opponent_dice(column_index, roll_value):
	
	var opponent_cols = p2_cols if player_turn == 1 else p1_cols
	var new_col = [];
	
	for i in opponent_cols[column_index]:
		#Get everything other than what the other player pulled
		if i != roll_value:
			new_col.append(i)
		#Fill with zero to complete 
	while new_col.size() < 3:
		new_col.append(0)
	
	opponent_cols[column_index] = new_col

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
	#check_game_over()
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
	if p1_health <= 0:
		game_over = true
		GameManager.winner_text = "Player 2 Wins!"
		SceneManager.change_scene("res://scenes/game_over.tscn")
	elif p2_health <= 0:
		game_over = true
		GameManager.winner_text = "Player 1 Wins!"
		SceneManager.change_scene("res://scenes/game_over.tscn")
	#KEEPING THIS COMMENTED FOR REFERENCE FOR THE 'CLASSIC' MODE IF NEEDED
	#var p1_full = true
	#for i in p1_cols:
		#if 0 in i:
			#p1_full = false
	#var p2_full = true
	#for i in p2_cols:
		#if 0 in i:
			#p2_full = false
	#
	#if p1_full or p2_full:
		#var p1_scores = calculate_column_score(p1_cols[0]) + calculate_column_score(p1_cols[1]) + calculate_column_score(p1_cols[2])
		#var p2_scores = calculate_column_score(p2_cols[0]) + calculate_column_score(p2_cols[1]) + calculate_column_score(p2_cols[2])
		#
		#if p1_scores > p2_scores:
			#GameManager.winner_text = "Player 1 Wins";
		#elif p1_scores < p2_scores:
			#GameManager.winner_text = "Player 2 Wins";
		#else:
			#GameManager.winner_text = "Its a draw!"
		#game_over = true
		#SceneManager.change_scene("res://scenes/game_over.tscn")

func computer_choice():
	var col_scores = [0,0,0] #Scores to figure out the best column
	var columns = [p2_cols[0], p2_cols[1], p2_cols[2]] #Get the value of the columns
	var opponet_columns = [p1_cols[0], p1_cols[1], p1_cols[2]] #Opponent column to figure out the best move
	
	for i in range(3):
		if columns[i][2] != 0:
			#If the column is filled no need to use it -> Lowest score
			col_scores[i] = -100
			continue
		
		for die in columns[i]:
			#For Double Score
			if die == current_roll:
				col_scores[i] += 10
		
		for die in opponet_columns[i]:
			#For destroying opponent dice
			if die == current_roll:
				col_scores[i] += 4
		
		for die in columns[i]:
			#Column has free space
			if die == 0:
				col_scores[i] += 1;
	var best_score  = -101;
	var best_col = 0
	for i in range(3):
		if col_scores[i] > best_score:
			best_col = i
			best_score = col_scores[i]
	return best_col

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
	place_dice(choice)#place the dice

func update_ui():
	var p1_score = calculate_column_score(p1_cols[0]) + calculate_column_score(p1_cols[1]) + calculate_column_score(p1_cols[2])
	var p2_score = calculate_column_score(p2_cols[0]) + calculate_column_score(p2_cols[1]) + calculate_column_score(p2_cols[2])
	
	p1_score_label.text = "P1 Score: " + str(p1_score) #Change the latest scores
	p2_score_label.text = "P2 Score: " + str(p2_score)
	# Player 1 dice roll
	if current_roll > 0 and player_turn == 1:
		player1_roll.set_die(dice_textures[current_roll - 1])
	else:
		player1_roll.set_die(null)
		
	# Player 2 dice roll
	if current_roll > 0 and player_turn == 2:
		player2_roll.set_die(dice_textures[current_roll - 1])
	else:
		player2_roll.set_die(null)

	#Display the current player's turn
	if current_roll == 0:
		turn_indicator_label.text = "Player 1's Turn: Roll the dice!" if player_turn == 1 else "Player 2's Turn: Roll the dice!"
	else:
		turn_indicator_label.text = "Player 1 Rolled: " + str(current_roll) if player_turn == 1 else "Player 2 Rolled: " + str(current_roll)

func update_board_visuals():
	
	for col_index  in range(p1_cols.size()):
		#Change the texture of the column based on what its corresponding value is
		for row_index in range(p1_cols[col_index].size()):
			var die_value = p1_cols[col_index][row_index]
			var slot_index = col_index + row_index * 3
			var slot = p1_grid.get_child(slot_index)
			if die_value > 0:
				slot.set_die(dice_textures[die_value - 1])
			else:
				slot.set_die(null)		
		
	for col_index  in range(p2_cols.size()):
		for row_index in range(p2_cols[col_index].size()):
			var flipped_row = p2_cols[col_index].size() - 1 - row_index
			var die_value = p2_cols[col_index][flipped_row]

			var slot_index = col_index + row_index * 3
			var slot = p2_grid.get_child(slot_index)
			if die_value > 0:
				slot.set_die(dice_textures[die_value - 1])
			else:
				slot.set_die(null)		

func _on_column_button_pressed(extra_arg_0: int) -> void:
	if game_over:
		return
	place_dice(extra_arg_0)
	
func _on_roll_button_pressed() -> void:
	if game_over:
		return
	
	roll_dice()
	update_ui()
	
	if player_turn == 1:
		$"UI-Elements/Player1RollButton".disabled = true
	else:
		$"UI-Elements/Player2RollButton".disabled = true


#Health bar system code:
func update_health_bars():
	$"UI-Elements/Player1Health".value = p1_health
	$"UI-Elements/Player2Health".value = p2_health

func perform_cash_in():
	if game_over:
		return
	
	var current_player_cols = p1_cols if player_turn == 1 else p2_cols
	var score_to_cash_in = calculate_column_score(current_player_cols[0]) + calculate_column_score(current_player_cols[1]) + calculate_column_score(current_player_cols[2])
	
	if score_to_cash_in > 0:
		if player_turn == 1:
			p2_health -= score_to_cash_in
		else:
			p1_health -= score_to_cash_in
	else:
		return
	p1_health = max(0,p1_health)
	p2_health = max(0,p2_health)
	update_health_bars();
	
	for i in range(3):
		for j in range(3):
			current_player_cols[i][j] = 0
	
	update_board_visuals()
	check_game_over()
	
	if !game_over:
		switch_turn()
	


func _on_player_1_cash_in_button_pressed() -> void:
	if player_turn == 1:
		perform_cash_in()


func _on_player_2_cash_in_button_pressed() -> void:
	if player_turn == 2:
		perform_cash_in()
