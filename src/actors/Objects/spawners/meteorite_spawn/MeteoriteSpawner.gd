extends Node2D


export (int) var numberOfMeteorites
export (float) var meteoriteSpawnTimer
export (Vector2) var randomMeteoritePosition

var meteoritePath = preload("res://src/actors/Objects/meteorite/meteorite.tscn")

func _ready():
	var rand = RandomNumberGenerator.new()
	while (true):
		yield(get_tree().create_timer(meteoriteSpawnTimer), "timeout")
		
		for i in range(0, numberOfMeteorites):
			var meteorite = meteoritePath.instance()
			randomize()
			var randXPos = rand.randf_range(0, randomMeteoritePosition.x)
			randomize()			
			var randYPos = rand.randf_range(0, randomMeteoritePosition.y)
			
			var meteoritePosition = Vector2(randXPos, randYPos)
			
			meteorite.position = meteoritePosition
			
			add_child(meteorite)
