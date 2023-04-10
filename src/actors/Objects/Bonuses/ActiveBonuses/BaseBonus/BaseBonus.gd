extends Area2D


export (float) var speed = 500.0

onready var aSprite = $AnimatedSprite
onready var border = $Border

func _ready():
	aSprite.playing = true
	border.playing = true

func _physics_process(delta):
	global_position.x -= speed * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _on_Bonus_area_entered(_area):
	if _area is MC:
		queue_free()
