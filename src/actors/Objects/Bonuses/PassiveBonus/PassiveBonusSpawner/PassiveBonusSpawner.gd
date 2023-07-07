extends Node2D

export (float) var nextSpawnTime = 1

export (bool) var damageBonus = true
export (bool) var hpBonus = true
export (bool) var shootSpeedBonus = true
export (bool) var multiplayerBonus = true
export (bool) var speedBonus = true


onready var pDamageBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveDamage/PassiveDamage.tscn"),
	"isSpawning": damageBonus	
}

onready var pHpBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveHP/PassiveHP.tscn"),
	"isSpawning": hpBonus	
}

onready var pShootSpeedBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveShootSpeed/PassiveSpeedShoot.tscn"),	
	"isSpawning": shootSpeedBonus	
}

onready var pMultiplayerBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveMulti/PassiveMulti.tscn"),
	"isSpawning": multiplayerBonus	
}

onready var pSpeedBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveSpeedMC/PassiveSpeedMC.tscn"),
	"isSpawning": speedBonus	
}

# Создаем массив всех объектов-бонусов
onready var preloadedBonuses = [
	pDamageBonus, 
	pHpBonus, 
	pMultiplayerBonus, 
	pShootSpeedBonus, 
	pSpeedBonus
]

onready var spawnTimer = $SpawnTimer
onready var viewportRect = get_viewport_rect()

var counter = 1

var activeBonuses = []

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)
	
	# Оставляем только активные бонусы
	for bonus in preloadedBonuses:
		if bonus["isSpawning"]:
			activeBonuses.append(bonus)

func _on_SpawnTimer_timeout():
# Spawn bonus
	var bonusPreloaded = activeBonuses[randi() % activeBonuses.size()]
	
	var bonus = bonusPreloaded["obj"].instance()
	

	# Position 
	bonus.position = Vector2($Position2D.global_position.x + 50, rand_range(30, viewportRect.end.y - 30))
	
	
		
	get_tree().current_scene.add_child(bonus)
	
#	if currentScore / 2500 > counter:
#		counter += 1
#		nextSpawnTime = 1.0
#	else:
#		nextSpawnTime = rand_range(nextSpawnTime, nextSpawnTime * 2)
#	# Restart timer
	spawnTimer.start(nextSpawnTime)

