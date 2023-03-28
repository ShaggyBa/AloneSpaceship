extends Node2D

# Чем дольше игра, тем меньше длительность этого таймера
export (float) var nextSpawnTime = 2.0
export (float) var minSpawnRate = 1.0
export (int) var maxEnemySpawn = 5

var enemies = []

var preloadedEnemies = [
	preload("res://src/actors/Enemies/FastEnemy/FastEnemy.tscn"),
	preload("res://src/actors/Enemies/ShooterEnemy/ShooterEnemy.tscn")
]
export (bool) var bossSpawning = true


onready var spawnTimer = $SpawnTimer
onready var viewportRect = get_viewport_rect()

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)


	

func _on_SpawnTimer_timeout():
	if get_tree().get_nodes_in_group("enemy").size() < maxEnemySpawn:
		
		# Создание врага
		var preloadedEnemy = preloadedEnemies[randi() % preloadedEnemies.size()]
		var enemy = preloadedEnemy.instance()
		
		
		if randf() < 0.3 and preloadedEnemy == preloadedEnemies[1] and bossSpawning:
			enemy.scale = Vector2(5, 5)
			enemy.enemyDamage = 5
			enemy.enemyAttackDelay = 0.1
			enemy.enemyHP = 30
			enemy.verticalSpeed = 10
		
		if preloadedEnemy == preloadedEnemies[1]:
			var enemyAttackDelay = enemy.enemyAttackDelay
			enemy.enemyAttackDelay = rand_range(enemyAttackDelay - 0.05, enemyAttackDelay + 0.25)	
		
		enemy.position = Vector2($Position2D.global_position.x, rand_range(0, viewportRect.end.y))
		
		if preloadedEnemy == preloadedEnemies[0]:
			var crntSpeed = enemy.horisontalSpeed
			enemy.horisontalSpeed = rand_range(crntSpeed - crntSpeed * 0.1, crntSpeed + crntSpeed * 0.2)
			enemy.position.y = get_tree().current_scene.get_node("MC").position.y	
			
		get_tree().current_scene.add_child(enemy)
		# if nextSpawnTime > minSpawnRate:
		#	nextSpawnTime -= 0.05 
			
		# Рестарт таймера
		spawnTimer.start(nextSpawnTime)
	else:
		spawnTimer.start(nextSpawnTime)
		
