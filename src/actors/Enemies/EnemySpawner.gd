extends Node2D

# Чем дольше игра, тем меньше длительность этого таймера
export (float) var nextSpawnTime = 5.0
export (float) var minSpawnRate = 1.0
export (int) var maxEnemySpawn = 5
export (bool) var changeSpawnRate = false 


var enemies = []

var preloadedEnemies = [
	preload("res://src/actors/Enemies/FastEnemy/FastEnemy.tscn"),
	preload("res://src/actors/Enemies/ShooterEnemy/ShooterEnemy.tscn")
]


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
		
			
		if preloadedEnemy == preloadedEnemies[1]:
			var enemyVerticalSpeed = enemy.verticalSpeed
			enemy.verticalSpeed = rand_range(enemyVerticalSpeed - 20, enemyVerticalSpeed + 50)	
			var enemyHorisontalSpeed = enemy.horisontalSpeed
			enemy.horisontalSpeed = rand_range(enemyHorisontalSpeed - 5, enemyHorisontalSpeed + 50)
		enemy.global_position = Vector2($Position2D.global_position.x, rand_range(25, viewportRect.end.y - 25))
		
		if preloadedEnemy == preloadedEnemies[0]:
			var crntSpeed = enemy.horisontalSpeed
			enemy.horisontalSpeed = rand_range(crntSpeed - crntSpeed * 0.1, crntSpeed + crntSpeed * 0.2)
			enemy.position.y = get_tree().current_scene.get_node("MC").position.y	
			
		get_tree().current_scene.add_child(enemy)
		
		if changeSpawnRate:
			if nextSpawnTime > minSpawnRate:
				nextSpawnTime -= 0.05 
			
		# Рестарт таймера
		spawnTimer.start(nextSpawnTime)
	else:
		spawnTimer.start(nextSpawnTime)
		
