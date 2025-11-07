class_name DiceTile
extends Node2D

signal selected(reference_to_self: DiceTile)

var is_touching_mouse: bool = false
var index := Vector2i.ZERO
var enabled: bool = false
var dice: Dice = null

@onready var Sprite = $Sprite2D as Sprite2D
@onready var size: float = Sprite.get_rect().size.x * Sprite.scale.x


func _on_area_2d_mouse_entered() -> void:
	is_touching_mouse = true


func _on_area_2d_mouse_exited() -> void:
	is_touching_mouse = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and is_touching_mouse and enabled:
		select()


func select() -> void:
	selected.emit(self)


func disable() -> void:
	if enabled:
		enabled = false


func enable() -> void:
	if not enabled:
		enabled = true
