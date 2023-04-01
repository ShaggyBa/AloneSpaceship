extends Area2D

class_name Bonus

signal pickBonus 

export (float) var speed = 500.0

func _physics_process(delta):
	global_position.x -= speed * delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_AroundShield_area_entered(area):
	emit_signal("pickBonus")
	queue_free()
