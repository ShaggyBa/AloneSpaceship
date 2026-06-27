extends Area2D


@export var shootSpeed: float = 500.0
var damage


var pShootEffect = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShootEffect.tscn")


func _ready():
	$Sprite2D.play()
func _physics_process(delta):
	global_position.x -= shootSpeed * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Shoot_area_entered(area):
	if area is MC or area.is_in_group("damageable"):
		DamageService.apply_damage(area, damage, self, &"projectile")
		var shootEffect = pShootEffect.instantiate()
		shootEffect.position = position
		SpawnService.spawn(shootEffect, get_parent())
		queue_free()

