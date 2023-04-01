extends Node2D

var preloadedBonuses = [
		preload("res://src/actors/Objects/Bonuses/BonusShield/ShieldBonus.tscn"),
		preload("res://src/actors/Objects/Bonuses/BonusHealth/HealthBonus.tscn")
	]

export (float) var nextSpawnTime = 5.0
export (int) var maxBonusSpawn = 2

onready var spawnTimer = $SpawnTimer
onready var viewportRect = get_viewport_rect()

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)

func _on_SpawnTimer_timeout():
	
	if get_tree().get_nodes_in_group("BonusEffects").size() < maxBonusSpawn:
	
		# Spawn bonus
		var bonusPreloaded = preloadedBonuses[randi() % preloadedBonuses.size()]
		var bonus = bonusPreloaded.instance()
		print("spawn")
	
		# Position 
		bonus.position = Vector2($Position2D.position.x, rand_range(0, viewportRect.end.y))
		get_tree().current_scene.add_child(bonus)
	
		# Restart timer
		spawnTimer.start(nextSpawnTime)
	else: 
		spawnTimer.start(nextSpawnTime)
		
