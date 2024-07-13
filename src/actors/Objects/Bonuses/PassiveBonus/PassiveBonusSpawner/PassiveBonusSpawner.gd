extends Node2D

@export var nextSpawnTime = 1.0

@export var damageBonus = true
@export var hpBonus = true
@export  var shootSpeedBonus = true
@export var multiplayerBonus = true
@export var speedBonus = true


@onready var pDamageBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveDamage/PassiveDamage.tscn"),
	"isSpawning": damageBonus	
}

@onready var pHpBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveHP/PassiveHP.tscn"),
	"isSpawning": hpBonus	
}

@onready var pShootSpeedBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveShootSpeed/PassiveSpeedShoot.tscn"),	
	"isSpawning": shootSpeedBonus	
}

@onready var pMultiplayerBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveMulti/PassiveMulti.tscn"),
	"isSpawning": multiplayerBonus	
}

@onready var pSpeedBonus:Dictionary = {
	"obj": preload("res://src/actors/Objects/Bonuses/PassiveBonus/passiveSpeedMC/PassiveSpeedMC.tscn"),
	"isSpawning": speedBonus	
}

# Создаем массив всех объектов-бонусов
@onready var preloadedBonuses = [
	pDamageBonus, 
	pHpBonus, 
	pMultiplayerBonus, 
	pShootSpeedBonus, 
	pSpeedBonus
]

@onready var spawnTimer = $SpawnTimer
@onready var viewportRect = get_viewport_rect()

var counter = 0

var activeBonuses = []

func _ready():
	randomize()

	spawnTimer.start(nextSpawnTime)
	
	# Оставляем только активные бонусы
	for bonus in preloadedBonuses:
		if bonus["isSpawning"]:
			activeBonuses.append(bonus)
	

func _on_SpawnTimer_timeout():
	var currentScore = Main.points
	
	if activeBonuses:
		var bonusPreloaded = activeBonuses[randi() % activeBonuses.size()]
		
		var bonus = bonusPreloaded["obj"].instantiate()
		

		# Position 
		bonus.position = Vector2($Marker2D.global_position.x + 50, randf_range(30, viewportRect.end.y - 30))
		
		
			
		get_tree().current_scene.add_child(bonus)
	
	# Restart timer
		spawnTimer.set_wait_time(randf_range(nextSpawnTime, nextSpawnTime * 2))
		spawnTimer.start()
		
