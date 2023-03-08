extends Node


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	$MeteoriteSpawner.global_position.x = $MC.global_position.x + 1000
