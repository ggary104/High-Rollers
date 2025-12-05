# scripts/Classic.gd
extends Node2D

# Variables - To store the main game logic data
var DiceSlotScene = preload("res://scenes/die_slot.tscn")
var player_turn = randi() % 2  + 1 # Is it player1's turn or player2's
var current_roll = 0 # Value of the current roll
var p1_cols = [[0, 0, 0], [0, 0, 0], [0, 0, 0]] # Player1 columns
var p2_cols = [[0, 0, 0], [0, 0, 0], [0, 0, 0]] # Player2 columns
var game_over = false 
var dice_textures = []

# Variables used in labels to display scores and turn
@onready var player1_column_inputs = $"Board/Player1Board/Player1ColumnInputs"
@onready var player2_column_inputs = $"Board/Player2Board/Player2ColumnInputs"
@onready var p1_grid = $Board/Player1Board/Player1Grid
@onready var p2_grid = $Board/Player2Board/Player2Grid
@onready var p1_score_label = $"UI-Elements/Player1Score"
@onready var p2_score_label = $"UI-Elements/Player2Score"
@onready var player1_roll = $"UI-Elements/Player1_UI/Player1RollButton" as Button
@onready var player2_roll = $"UI-Elements/Player2_UI/Player2RollButton" as Button

@onready var roll_animation = $"UI-Elements/DiceRoll/RollAnimation"
@onready var dice_roll = $"UI-Elements/DiceRoll"

func _ready():
	# Load dice images
	for i in range(1, 7):
		dice_textures.append(load("res://assets/dice_" + str(i) + ".svg"))
	
	# Fill grids with DiceSlotScene
	for i in range(9):
		p1_grid.add_child(DiceSlotScene.instantiate())
		p2_grid.add_child(DiceSlotScene.instantiate())
	
	# Start with roll buttons invisible
	player1_roll.disabled = player_turn != 1
	player2_roll.disabled = player_turn != 2

	
	# Connect roll buttons
	player1_roll.pressed.connect(_on_player1_roll_pressed)
	player2_roll.pressed.connect(_on_player2_roll_pressed)
	
	if player_turn == 1:
		player_one_turn()
	else:
		player_two_turn()

# --- Turn logic ---
func player_one_turn():
	for button in player1_column_inputs.get_children():
		button.disabled = false
	for button in player2_column_inputs.get_children():
		button.disabled = true
	player1_roll.disabled = false
	player2_roll.disabled = true
	update_ui()
		

	update_ui()

func player_two_turn():
	if GameManager.playerNumber == 1:
		# AI turn
		for button in player1_column_inputs.get_children():
			button.disabled = true
		for button in player2_column_inputs.get_children():
			button.disabled = true
		player1_roll.disabled = true
		player2_roll.disabled = true

		computer_turn()
	else:
		# Human player 2 turn
		for button in player1_column_inputs.get_children():
			button.disabled = true
		for button in player2_column_inputs.get_children():
			button.disabled = false
		player1_roll.disabled = true
		player2_roll.disabled = false
		update_ui()


# --- Dice rolling ---
func roll_dice() -> void:
	dice_roll.visible = true
	roll_animation.stop() # Reset animation
	roll_animation.play("roll")
	await roll_animation.animation_finished
	dice_roll.visible = false
	current_roll = randi() % 6 + 1



# --- Place dice in column ---
func place_dice(column_index):
	if current_roll == 0:
		return
	
	var current_player_cols = p1_cols if player_turn == 1 else p2_cols
	
	for i in range(3):
		if current_player_cols[column_index][i] == 0:
			current_player_cols[column_index][i] = current_roll
			remove_opponent_dice(column_index, current_roll)
			update_board_visuals()
			switch_turn()
			return


func remove_opponent_dice(column_index, roll_value):
	var opponent_cols = p2_cols if player_turn == 1 else p1_cols
	var new_col = []
	for i in opponent_cols[column_index]:
		if i != roll_value:
			new_col.append(i)
	while new_col.size() < 3:
		new_col.append(0)
	opponent_cols[column_index] = new_col

func calculate_column_score(column):
	var score = 0
	var counts = {}
	for die_value in column:
		if die_value > 0:
			if not counts.has(die_value):
				counts[die_value] = 0
			counts[die_value] += 1
	for die_value in counts:
		var num_of_dice = counts[die_value]
		score += num_of_dice * die_value * num_of_dice
	return score

func switch_turn():
	check_game_over()
	player_turn = 2 if player_turn == 1 else 1
	current_roll = 0
	update_ui()
	if player_turn == 1:
		player_one_turn()
	else:
		player_two_turn()

func check_game_over():
	var p1_full = true
	for i in p1_cols:
		if 0 in i:
			p1_full = false
	var p2_full = true
	for i in p2_cols:
		if 0 in i:
			p2_full = false
	
	if p1_full or p2_full:
		var p1_scores = calculate_column_score(p1_cols[0]) + calculate_column_score(p1_cols[1]) + calculate_column_score(p1_cols[2])
		var p2_scores = calculate_column_score(p2_cols[0]) + calculate_column_score(p2_cols[1]) + calculate_column_score(p2_cols[2])
		
		if p1_scores > p2_scores:
			GameManager.winner_text = "Player 1 Wins"
		elif p1_scores < p2_scores:
			GameManager.winner_text = "Player 2 Wins"
		else:
			GameManager.winner_text = "It's a draw!"
		game_over = true
		SceneManager.change_scene("res://scenes/game_over.tscn")

# --- Computer AI ---
func computer_choice():
	var col_scores = [0,0,0]
	var columns = [p2_cols[0], p2_cols[1], p2_cols[2]]
	var opponent_columns = [p1_cols[0], p1_cols[1], p1_cols[2]]
	
	for i in range(3):
		if columns[i][2] != 0:
			col_scores[i] = -100
			continue
		for die in columns[i]:
			if die == current_roll:
				col_scores[i] += 10
		for die in opponent_columns[i]:
			if die == current_roll:
				col_scores[i] += 4
		for die in columns[i]:
			if die == 0:
				col_scores[i] += 1
	var best_score = -101
	var best_col = 0
	for i in range(3):
		if col_scores[i] > best_score:
			best_col = i
			best_score = col_scores[i]
	return best_col

func computer_turn():
	if game_over: return
	
	# Disable buttons
	for button in player1_column_inputs.get_children():
		button.disabled = true
	for button in player2_column_inputs.get_children():
		button.disabled = true
	player1_roll.disabled = true
	player2_roll.disabled = true

	await get_tree().create_timer(0.8).timeout
	await roll_dice()
	update_ui()
	await get_tree().create_timer(0.8).timeout

	var choice = computer_choice()
	place_dice(choice) 


# --- UI updates ---
func update_ui():
	var p1_score = calculate_column_score(p1_cols[0]) + calculate_column_score(p1_cols[1]) + calculate_column_score(p1_cols[2])
	var p2_score = calculate_column_score(p2_cols[0]) + calculate_column_score(p2_cols[1]) + calculate_column_score(p2_cols[2])
	
	p1_score_label.text = "P1 Score: " + str(p1_score)
	p2_score_label.text = "P2 Score: " + str(p2_score)
	

# --- Update board visuals ---
func update_board_visuals():
	for col_index in range(3):
		var counts = {}
		for die_value in p1_cols[col_index]:
			if die_value > 0:
				if not counts.has(die_value):
					counts[die_value] = 0
				counts[die_value] += 1
		for row_index in range(3):
			var die_value = p1_cols[col_index][row_index]
			var slot_index = col_index + row_index * 3
			var slot = p1_grid.get_child(slot_index)
			if die_value > 0:
				if counts[die_value] == 3:
					slot.texture = load("res://assets/dice_%d_triple.svg" % die_value)
				elif counts[die_value] == 2:
					slot.texture = load("res://assets/dice_%d_double.svg" % die_value)
				else:
					slot.texture = dice_textures[die_value - 1]
			else:
				slot.texture = null
	# Player 2
	for col_index in range(3):
		var counts = {}
		for die_value in p2_cols[col_index]:
			if die_value > 0:
				if not counts.has(die_value):
					counts[die_value] = 0
				counts[die_value] += 1
		for row_index in range(3):
			var flipped_row = 2 - row_index
			var die_value = p2_cols[col_index][flipped_row]
			var slot_index = col_index + row_index * 3
			var slot = p2_grid.get_child(slot_index)
			if die_value > 0:
				if counts[die_value] == 3:
					slot.texture = load("res://assets/dice_%d_triple.svg" % die_value)
				elif counts[die_value] == 2:
					slot.texture = load("res://assets/dice_%d_double.svg" % die_value)
				else:
					slot.texture = dice_textures[die_value - 1]
			else:
				slot.texture = null

# --- Button handlers ---
func _on_player1_roll_pressed():
	if game_over or player_turn != 1:
		return
	player1_roll.disabled = true
	await roll_dice()
	update_ui()

func _on_player2_roll_pressed():
	if game_over or player_turn != 2:
		return
	player2_roll.disabled = true
	await roll_dice()
	update_ui()

# --- Column button pressed ---
func _on_column_button_pressed(extra_arg_0: int):
	if game_over:
		return
	place_dice(extra_arg_0)
