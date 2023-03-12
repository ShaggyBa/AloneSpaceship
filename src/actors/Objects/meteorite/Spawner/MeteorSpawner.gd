extends Node2D

#создаем массив объектов из которого будем спавнить врагов
var preloadMeteors := [
preload("res://src/actors/Objects/meteorite/Meteor_1/meteorite.tscn"),
preload("res://src/actors/Objects/meteorite/Meteor_2/meteorite_2.tscn"),
preload("res://src/actors/Objects/meteorite/Meteor_3/meteorite_3.tscn")
]

onready var spawnTimer := $SpawnTimer

var nextSpawnTime := 1.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)
	
func _on_SpawnTimer_timeout():
	#спавн метеоров
	var ViewRect := get_viewport_rect()
	var yPos := rand_range(ViewRect.position.y, ViewRect.end.y)
	var meteorPreload = preloadMeteors[randi() % preloadMeteors.size()]
	var meteor: Meteorite = meteorPreload.instance()
	meteor.position = Vector2(position.x, yPos)
	get_tree().current_scene.add_child(meteor)
	print('spawn')

	#рестарт таймера
	spawnTimer.start(nextSpawnTime)

