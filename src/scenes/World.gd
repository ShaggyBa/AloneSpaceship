extends Node


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	$MeteoriteSpawner.global_position.x += $MC.mcSpeed * delta
	$EnemySpawner.global_position.x += $MC.mcSpeed * delta
