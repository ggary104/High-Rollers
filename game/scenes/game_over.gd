extends Control

@onready var ResultLabel = $VBoxContainer/Result as Label

func _ready() -> void:
	$VBoxContainer/Result.text = GameManager.winner_text


func _on_play_again_button_pressed() -> void:
	if GameManager.gameMode == "game":
		SceneManager.change_scene("res://scenes/game.tscn")
	elif GameManager.gameMode == "classic":
		SceneManager.change_scene("res://scenes/classic.tscn")
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")
	pass # Replace with function body.
