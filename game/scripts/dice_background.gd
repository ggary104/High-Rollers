extends Node2D

var Particle := preload("res://scenes/background_dice.tscn")

@onready var timer = $Timer as Timer

var previous_x_positions: Array = []
const previous_x_positions_size = 20
var random_x: int
var min_distance: int = 50


func _ready() -> void:
	for i: int in range(190):
		var y_pos: int = i*5
		spawn_dice(y_pos)


func _on_timer_timeout() -> void:
	spawn_dice(1000)


func spawn_dice(y_position: int) -> void:
	var particle: AnimatedSprite2D = Particle.instantiate()
	add_child(particle)
	particle.global_position.x = get_random_x_position()
	particle.global_position.y = y_position


func get_random_x_position() -> int:
	random_x = randi() % 1601
	
	while not previous_x_positions.all(is_distance_away):
		random_x = randi() % 1601
	
	if previous_x_positions.size() == previous_x_positions_size:
		previous_x_positions.pop_front()
	
	previous_x_positions.append(random_x)
	return random_x


func is_distance_away(x_position) -> bool:
	var distance: int = x_position - random_x
	if abs(distance) < min_distance:
		return false
	
	return true
