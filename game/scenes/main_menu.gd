extends Control


func _on_player_one_button_pressed() -> void:
	GameManager.playerNumber = 1
	SceneManager.change_scene("res://scenes/game.tscn")


func _on_player_two_button_pressed() -> void:
	GameManager.playerNumber = 2
	SceneManager.change_scene("res://scenes/game.tscn")
