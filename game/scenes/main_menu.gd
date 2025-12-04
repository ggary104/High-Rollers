extends Control


enum GAME_MODE {HOT_DICE, CLASSIC}
var selected_game_mode: int = GAME_MODE.HOT_DICE
var player_count: int = 1

const PATH_TO_CLASSIC_MODE: String = "res://scenes/classic.tscn"
const PATH_TO_HOT_DICE_MODE: String = "res://scenes/game.tscn"


@onready var hot_dice_button = $VBoxContainer/HBoxContainer/HotDiceButton as Button
@onready var classic_mode_button = $VBoxContainer/HBoxContainer/classicButton as Button
@onready var one_player_button = $VBoxContainer/HBoxContainer2/OnePlayerButton as Button
@onready var two_player_button = $VBoxContainer/HBoxContainer2/TwoPlayerButton as Button
@onready var click_sfx = $Click_SFX as AudioStreamPlayer


func _on_base_game_button_pressed() -> void:
	selected_game_mode = GAME_MODE.HOT_DICE
	hot_dice_button.disabled = true
	classic_mode_button.button_pressed = false
	classic_mode_button.disabled = false
	click_sfx.play()


func _on_classic_button_pressed() -> void:
	selected_game_mode = GAME_MODE.CLASSIC
	classic_mode_button.disabled = true
	hot_dice_button.button_pressed = false
	hot_dice_button.disabled = false
	click_sfx.play()


func _on_one_player_button_pressed() -> void:
	player_count = 1
	one_player_button.disabled = true
	two_player_button.button_pressed = false
	two_player_button.disabled = false
	click_sfx.play()


func _on_two_player_button_pressed() -> void:
	player_count = 2
	two_player_button.disabled = true
	one_player_button.button_pressed = false
	one_player_button.disabled = false
	click_sfx.play()


func _on_start_button_pressed() -> void:
	click_sfx.play()
	GameManager.playerNumber = player_count
	if selected_game_mode == GAME_MODE.HOT_DICE:
		SceneManager.change_scene(PATH_TO_HOT_DICE_MODE)
	elif selected_game_mode == GAME_MODE.CLASSIC:
		SceneManager.change_scene(PATH_TO_CLASSIC_MODE)
