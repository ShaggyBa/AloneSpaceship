extends ShootClass

var scaleShoot = Vector2(1, 1)

var bonusShootEffect = preload("res://src/actors/Projectiles/BonusShootEffect/BonusShootEffect.tscn")

func _process(delta):
	scale += scaleShoot * delta * 3

func _on_Shoot_area_entered(area):
	if (area.is_in_group("damageable")):
		area.takeDamage(damage)
		var shootEffect = bonusShootEffect.instance()
		shootEffect.position = position
		get_parent().add_child(shootEffect)
	
	
