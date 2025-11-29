class_name Dice
extends Node2D


signal on_dice_1_destroyed
signal on_dice_destroyed

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D


var score_value: int = 0 # What this dice adds to the total score
# What this dice shows in the grid 
# e.g. if they pulled 6, it must show 6 in the board but its value is different
var face_value: int = 0
var is_placed: bool = false


func set_score_value(new_score_value: int) -> void:
	face_value = new_score_value
	score_value = new_score_value
	play_face_value()


# Used to set the value for Dice 6 - According to its effect
func set_score_value_special(average_board_value: float, actual_face_value: int) -> void:
	face_value = actual_face_value # It shows in the grid that they pulled 6
	score_value = get_special_adjusted_score_value(average_board_value) 
	play_face_value()


# Helper function to diplay the right dice
func play_face_value() -> void:
	var face_value_as_string: String = str(face_value)
	sprite.play(face_value_as_string)


# Helper function to calculate the value of the dice 6
func get_special_adjusted_score_value(average_board_value:float) -> int:
	# How much higher or lower is the average board value from 3.5
	var diff: float = average_board_value - 3.5 
	# For every 0.5 -> Value changes by one wether -ve or +ve
	var adjusted_value: int = round(diff / 0.5) 
	var temp_score_value: int = 6 + adjusted_value #new value of 6
	
	if temp_score_value < 1: 
		temp_score_value = 1
		
	return temp_score_value


func get_score_value() -> int:
	return score_value


func get_face_value() -> int:
	return face_value


func destroy() -> void:
	destroyed_effect()
	queue_free()


func destroyed_effect() -> void:
	if score_value == 1 and is_placed:
		on_dice_1_destroyed.emit()
	
	if is_placed:
		is_placed = false
	
	on_dice_destroyed.emit()
