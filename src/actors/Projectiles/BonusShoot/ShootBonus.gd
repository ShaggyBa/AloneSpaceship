extends ShootClass

var scaleShoot = Vector2(1, 1)

func _process(delta):
	scale += scaleShoot * delta * 3

func _on_Shoot_area_entered(area):
	if (area.is_in_group("damageable")):
		area.takeDamage(damage)
		var shootEffect = pShootEffect.instance()
		shootEffect.position = position
		get_parent().add_child(shootEffect)
	
	
