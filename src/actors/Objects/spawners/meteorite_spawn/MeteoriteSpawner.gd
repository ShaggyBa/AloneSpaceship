extends Node2D


@export var numberOfMeteorites: int
@export var meteoriteSpawnTimer: float
@export var randomMeteoritePosition: Vector2
var meteoritePath = preload("res://src/actors/Objects/meteorite/meteorite.tscn")

func _ready():
	var rand = RandomNumberGenerator.new()
	while (true):
		await get_tree().create_timer(meteoriteSpawnTimer).timeout
		
		for i in range(0, numberOfMeteorites):
			var meteorite = meteoritePath.instantiate()
			randomize()
			var randXPos = rand.randf_range(0, randomMeteoritePosition.x)
			randomize()			
			var randYPos = rand.randf_range(0, randomMeteoritePosition.y)
			
			var meteoritePosition = Vector2(randXPos, randYPos)
			
			meteorite.position = meteoritePosition
			
			add_child(meteorite)
