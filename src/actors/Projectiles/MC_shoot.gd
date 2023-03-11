extends Area2D

export (float) var shootSpeed = 1000.0

func _on_Shoot_area_entered(area):
	if area.is_in_group("meteorites"):
		area.takeDamage(1)
		queue_free()

func _physics_process(delta):
	global_position.x += shootSpeed * delta

# Когда выстрел покидает экран
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
