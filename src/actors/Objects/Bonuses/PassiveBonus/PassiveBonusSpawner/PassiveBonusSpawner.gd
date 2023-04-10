extends Node2D

export (float) var nextSpawnTime = 1

onready var preloadedBonuses = [
		preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveDamage/PassiveDamage.tscn"),
		preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveHP/PassiveHP.tscn"),
		preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveShootSpeed/PassiveSpeedShoot.tscn"),
		preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveMulti/PassiveMulti.tscn"),
		preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveSpeedMC/PassiveSpeedMC.tscn")		
	]


onready var spawnTimer = $SpawnTimer
onready var viewportRect = get_viewport_rect()

var counter = 1

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)

func _on_SpawnTimer_timeout():
	var currentScore = get_tree().current_scene.get_node("GUI/Control/HBoxContainer/VBoxContainer4/ScoreCounter").get_points()	
# Spawn bonus
	var bonusPreloaded = preloadedBonuses[randi() % preloadedBonuses.size()]
	var bonus = bonusPreloaded.instance()
	

	# Position 
	bonus.position = Vector2($Position2D.global_position.x + 50, rand_range(0, viewportRect.end.y))
	
	
		
	get_tree().current_scene.add_child(bonus)
	
	if currentScore / 2500 > counter:
		counter += 1
		nextSpawnTime = 1.0
	else:
		nextSpawnTime = rand_range(nextSpawnTime, nextSpawnTime * 2)
	# Restart timer
	spawnTimer.start(nextSpawnTime)

