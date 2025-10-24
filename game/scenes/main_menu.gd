extends Control


func _on_base_game_button_pressed():
	GameManager.gameMode = "game"
	SceneManager.change_scene("res://scenes/options_menu.tscn")


func _on_classic_button_pressed():
	GameManager.gameMode = "classic"
	SceneManager.change_scene("res://scenes/options_menu.tscn")
	
