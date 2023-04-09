extends Area2D

class_name Bonus

export (float) var speed = 500.0

func _ready():
	$AnimatedSprite.playing = true
	$Border.playing = true

func _physics_process(delta):
	global_position.x -= speed * delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Bonus_area_entered(area):
	queue_free()
