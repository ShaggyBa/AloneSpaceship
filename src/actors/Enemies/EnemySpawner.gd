extends Node2D

# Чем дольше игра, тем меньше длительность этого таймера
export (float) var nextSpawnTime = 5.0
export (float) var minSpawnRate = 1.0
export (int) var maxEnemySpawn = 5

var enemies = []

var preloadedEnemies = [
	preload("res://src/actors/Enemies/FastEnemy/FastEnemy.tscn"),
	preload("res://src/actors/Enemies/ShooterEnemy/ShooterEnemy.tscn")
]


var pBoss = preload("res://src/actors/Enemies/BattleEnemy/BattleEnemy.tscn")


export (bool) var bossSpawning = true
export (float) var nextBossSpawn = 2


onready var spawnTimer = $SpawnTimer
onready var bossTimer = $BossTimer

onready var viewportRect = get_viewport_rect()

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)
	bossTimer.start(nextBossSpawn)

	

func _on_SpawnTimer_timeout():
	if get_tree().get_nodes_in_group("enemy").size() < maxEnemySpawn:
		
		# Создание врага
		var preloadedEnemy = preloadedEnemies[randi() % preloadedEnemies.size()]
		var enemy = preloadedEnemy.instance()
		
		
		if bossSpawning and bossTimer.is_stopped():
			var boss = pBoss.instance()
			boss.global_position = Vector2($Position2D.global_position.x, viewportRect.end.y / 2)
			get_tree().current_scene.add_child(boss)
			print("add boss")
			bossTimer.start(nextBossSpawn)
			
		if preloadedEnemy == preloadedEnemies[1]:
			var enemyAttackDelay = enemy.enemyAttackDelay
			enemy.enemyAttackDelay = rand_range(enemyAttackDelay - 0.05, enemyAttackDelay + 0.25)	
		
		enemy.global_position = Vector2($Position2D.global_position.x, rand_range(25, viewportRect.end.y - 25))
		
		if preloadedEnemy == preloadedEnemies[0]:
			var crntSpeed = enemy.horisontalSpeed
			enemy.horisontalSpeed = rand_range(crntSpeed - crntSpeed * 0.1, crntSpeed + crntSpeed * 0.2)
			enemy.global_position.y = get_tree().current_scene.get_node("MC").position.y	
			
		get_tree().current_scene.add_child(enemy)
		
		# if nextSpawnTime > minSpawnRate:
		#	nextSpawnTime -= 0.05 
			
		# Рестарт таймера
		spawnTimer.start(nextSpawnTime)
	else:
		spawnTimer.start(nextSpawnTime)
		
