extends Area2D

class_name PassiveBonus

@export var speed: float = 500.0

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play()
func _physics_process(delta):
	global_position.x -= speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bonus_area_entered(area):
	if area is MC:
		area.apply_bonus(self)
	queue_free()
