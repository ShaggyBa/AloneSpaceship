extends Area2D


export (float) var shootSpeed = 500.0
export (int) var damage = 1


var pShootEffect = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShootEffect.tscn")


func _physics_process(delta):
	global_position.x -= shootSpeed * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Shoot_area_entered(area):
	if area is MC or area.is_in_group("damageable"):
		area.takeDamage(damage)
		var shootEffect = pShootEffect.instance()
		shootEffect.position = position
		get_parent().add_child(shootEffect)
		queue_free()

