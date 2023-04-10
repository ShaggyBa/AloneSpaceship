extends Node2D

var preloadedBonuses = [
		preload("res://src/actors/Objects/Bonuses/ActiveBonus/BonusShield/ShieldBonus.tscn"),
		preload("res://src/actors/Objects/Bonuses/ActiveBonus/BonusHealth/HealthBonus.tscn"),
		preload("res://src/actors/Objects/Bonuses/ActiveBonus/BonusDamage/DamageBonus.tscn"),
	]

var nextSpawnTime = null
export (int) var maxBonusSpawn = 3

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
		
		spawnBonus()
		
		# Position 
		bonus.position = Vector2($Position2D.global_position.x + 50, rand_range(30, viewportRect.end.y - 30))
		get_tree().current_scene.add_child(bonus)
	
		# Restart timer
		spawnTimer.start(nextSpawnTime)
	else: 
		spawnTimer.start(nextSpawnTime)

func spawnBonus():
	nextSpawnTime = randi() % 10 + 5
	print("spawn")
		
