class_name AudioManager
extends Node

var old_pitch: float = 0

@onready var roll_sfx = $Roll_SFX as AudioStreamPlayer
@onready var place_sfx = $Place_SFX as AudioStreamPlayer
@onready var skip_sfx = $Skip_SFX as AudioStreamPlayer
@onready var attack_sfx = $Attack_SFX as AudioStreamPlayer
@onready var heal_sfx = $Heal_SFX as AudioStreamPlayer
@onready var destroy_sfx = $Destroy_SFX as AudioStreamPlayer
