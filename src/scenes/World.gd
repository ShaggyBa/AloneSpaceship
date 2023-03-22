extends Node

var points := 0.0

onready var counter := $CanvasLayer/Interface/Counter2

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	$MeteoriteSpawner.global_position.x = $MC.global_position.x + 1000
	points += delta * 25
	counter.set_points(floor(points))
	

