class_name DiceTile
extends Node2D

signal selected(reference_to_self)

var mouse_entered := false
var index := Vector2.ZERO
var enabled := false
var dice = null

@onready var Sprite = $Sprite2D
@onready var size = Sprite.get_rect().size.x * Sprite.scale.x


func _on_area_2d_mouse_entered() -> void:
	mouse_entered = true


func _on_area_2d_mouse_exited() -> void:
	mouse_entered = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and mouse_entered and enabled:
		select()


func select() -> void:
	selected.emit(self)


func disable() -> void:
	if enabled:
		enabled = false


func enable() -> void:
	if not enabled:
		enabled = true
