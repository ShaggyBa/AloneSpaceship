extends Node2D

var preloadedBonuses = [
		preload("res://src/actors/Objects/Bonuses/ActiveBonus/BonusShield/ShieldBonus.tscn"),
		preload("res://src/actors/Objects/Bonuses/ActiveBonus/BonusHealth/HealthBonus.tscn"),
		preload("res://src/actors/Objects/Bonuses/ActiveBonus/BonusDamage/DamageBonus.tscn"),
	]

@export (float) var nextSpawnTime = 3.0

@onready var spawnTimer = $SpawnTimer
@onready var viewportRect = get_viewport_rect()

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)

func _on_SpawnTimer_timeout():
	var bonusPreloaded = preloadedBonuses[randi() % preloadedBonuses.size()]
	var bonus = bonusPreloaded.instantiate()
	
	# Position 
	bonus.position = Vector2($Marker2D.global_position.x + 50, randf_range(30, viewportRect.end.y - 30))
	get_tree().current_scene.add_child(bonus)

	spawnTimer.set_wait_time(randf_range(nextSpawnTime / 2, nextSpawnTime * 2))
	spawnTimer.start()
