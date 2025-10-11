extends Control


func _on_player_two_button_pressed():
	GameManager.playerNumber = 1
	SceneManager.change_scene("res://scenes/main_game.tscn")


func _on_player_one_button_pressed():
	GameManager.playerNumber = 2
	SceneManager.change_scene("res://scenes/main_game.tscn")
	pass # Replace with function body.
