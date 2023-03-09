extends Node


var _shoot = preload("res://src/actors/Projectiles/MC_shoot.tscn")


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	$MeteoriteSpawner.global_position.x = $MC.global_position.x + 1000


func _on_MC_spawnShoot(location):
	var shoot = _shoot.instance()
	shoot.global_position = location
	add_child(shoot)
