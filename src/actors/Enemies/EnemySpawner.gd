extends Node2D

# Чем дольше игра, тем меньше длительность этого таймера
export (float) var nextSpawnTime = 2.0


var preloadedEnemies = [
	preload("res://src/actors/Enemies/FastEnemy/FastEnemy.tscn"),
	preload("res://src/actors/Enemies/ShooterEnemy/ShooterEnemy.tscn")
]
export (bool) var bossSpawning = true


onready var spawnTimer = $SpawnTimer
onready var viewportRect = get_viewport_rect()

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime )
	

func _process(delta):
	pass


func _on_SpawnTimer_timeout():
	# Создание врага
	var preloadedEnemy = preloadedEnemies[randi() % preloadedEnemies.size()]
	var enemy = preloadedEnemy.instance()
	
	if randf() < 0.3 and preloadedEnemy == preloadedEnemies[1] and bossSpawning:
		enemy.scale = Vector2(5, 5)
		enemy.enemyDamage = 5
		enemy.enemyAttackDelay = 0.1
		enemy.enemyHP = 10
		enemy.verticalSpeed = 45
	
	if preloadedEnemy == preloadedEnemies[1]:	
		var enemyAttackDelay = enemy.enemyAttackDelay
		enemy.enemyAttackDelay = rand_range(enemyAttackDelay - 0.05, enemyAttackDelay + 0.05)	
	
	enemy.global_position = Vector2(global_position.x - 200, rand_range(0, viewportRect.end.y))
	get_tree().current_scene.add_child(enemy)
	print("Enemy spawn", enemy.global_position)
	# Рестарт таймера
	spawnTimer.start(nextSpawnTime)
	
