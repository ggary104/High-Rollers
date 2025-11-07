class_name Dice
extends Node2D


signal on_dice_1_destroyed

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D

var score_value: int = 0:
	set = set_score_value,
	get = get_score_value


func _ready() -> void:
	pass 


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
	if score_value == 1:
		on_dice_1_destroyed.emit()
