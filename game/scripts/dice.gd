class_name Dice
extends Node2D


signal on_dice_1_destroyed
signal on_dice_destroyed

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D


var score_value: int = 0:
	set = set_score_value,
	get = get_score_value

var is_placed: bool = false


func set_score_value(new_score_value: int) -> void:
	score_value = new_score_value
	var score_value_as_string: String = str(score_value)
	sprite.play(score_value_as_string)


func get_score_value() -> int:
	return score_value


func destroy() -> void:
	destroyed_effect()
	queue_free()


func destroyed_effect() -> void:
	if score_value == 1 and is_placed:
		on_dice_1_destroyed.emit()
	
	if is_placed:
		is_placed = false
	
	on_dice_destroyed.emit()
