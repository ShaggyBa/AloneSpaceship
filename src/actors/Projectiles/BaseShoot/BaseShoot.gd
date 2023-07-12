extends Area2D

class_name ShootClass

export (float) var shootSpeed = 1000.0


var pShootEffect = preload("res://src/actors/Projectiles/BaseShootEffect/BaseShootEffect.tscn")

var damage

func _physics_process(delta):
	global_position.x += shootSpeed * delta

# Когда выстрел покидает экран
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Shoot_area_entered(area):
	if (area.is_in_group("damageable")):
		area.takeDamage(damage)
		var shootEffect = pShootEffect.instance()
		shootEffect.position = position
		get_parent().add_child(shootEffect)
		if area.is_in_group("enemy"):
			if damage > area.enemyHP :
				damage -= area.enemyHP
				return
		queue_free()

