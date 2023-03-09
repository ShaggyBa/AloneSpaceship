extends Area2D

export (float) var shootSpeed = 1000.0

func _on_Shoot_area_entered(area):
	if area.is_in_group("meteorites"):
		area.takeDamage(1)


func _physics_process(delta):
	global_position.x += shootSpeed * delta
