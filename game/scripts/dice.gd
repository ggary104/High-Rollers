class_name Dice
extends Node2D

@onready var sprite = $AnimatedSprite2D

var score_value:int = 0:
	set = set_score_value,
	get = get_score_value


func _ready() -> void:
	pass 


func set_score_value(new_score_value:int) -> void:
	score_value = new_score_value
	sprite.play(str(score_value))


func get_score_value() -> int:
	return score_value


func destroy() -> void:
	queue_free()
