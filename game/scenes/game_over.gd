extends Control

func _ready():
	$VBoxContainer/Result.text = GameManager.winner_text


func _on_play_again_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/game.tscn")
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")
	pass # Replace with function body.
