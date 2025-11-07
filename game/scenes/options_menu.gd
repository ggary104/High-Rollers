extends Control


func _on_player_one_button_pressed() -> void:
	GameManager.playerNumber = 1
	if GameManager.gameMode == "classic":
		SceneManager.change_scene("res://scenes/classic.tscn")
	elif GameManager.gameMode == "game":
		SceneManager.change_scene("res://scenes/game.tscn")


func _on_player_two_button_pressed() -> void:
	GameManager.playerNumber = 2
	if GameManager.gameMode == "classic":
		SceneManager.change_scene("res://scenes/classic.tscn")
	elif GameManager.gameMode == "game":
		SceneManager.change_scene("res://scenes/game.tscn")
