extends Node2D

#создаем массив объектов из которого будем спавнить врагов
var preloadMeteors := [
preload("res://src/actors/Objects/meteorite/MeteoriteMain/meteorite.tscn"),
preload("res://src/actors/Objects/meteorite/MeteorCopy1/meteorite_2.tscn"),
preload("res://src/actors/Objects/meteorite/MeteorCopy2/meteorite_3.tscn")
]

@onready var timer := $SpawnTimer

@export (float) var spawnTimer := 1.0

func _ready():
	randomize()
	timer.start(spawnTimer)
	
func _on_SpawnTimer_timeout():
	#спавн метеоров
	var ViewRect := get_viewport_rect()
	var yPos := randf_range(0, ViewRect.end.y)
	var meteorPreload = preloadMeteors[randi() % preloadMeteors.size()]
	var meteor = meteorPreload.instantiate()
	meteor.position = Vector2($Marker2D.global_position.x, yPos)
	get_tree().current_scene.add_child(meteor)
	#рестарт таймера
	timer.start(spawnTimer)

