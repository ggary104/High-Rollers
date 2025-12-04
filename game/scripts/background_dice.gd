extends AnimatedSprite2D

@onready var on_screen_notifier = $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D

var speed: int = 20
var rotation_speed: int = 2

func _ready() -> void:
	#speed = randi() % 25 + 25
	rotation_degrees = randi() % 360
	rotation_speed = randi() % 4 + 4
	var random_scale: float = randi() % 40 + 40
	random_scale /= 100
	scale.x = random_scale
	scale.y = random_scale
	var random_dice_number: int = randi() % 6 + 1
	play(str(random_dice_number))

func _process(delta: float) -> void:
	global_position.y -= speed * delta
	#rotation_degrees += rotation_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
