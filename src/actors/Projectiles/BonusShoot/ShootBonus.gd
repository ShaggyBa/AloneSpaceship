extends ShootClass

var scaleShoot = Vector2(1, 1)

var bonusShootEffect = preload("res://src/actors/Projectiles/BonusShootEffect/BonusShootEffect.tscn")

@onready var sprite = $Sprite2D


func _ready():
	sprite.play()
func _process(delta):
	scale += scaleShoot * delta * 10

func _on_Shoot_area_entered(area):
	if (area.is_in_group("damageable")):
		DamageService.apply_damage(area, damage, self, &"projectile")
		var shootEffect = bonusShootEffect.instantiate()
		shootEffect.position = position
		SpawnService.spawn(shootEffect, get_parent())
	
	
