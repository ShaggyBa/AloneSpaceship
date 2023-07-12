extends Node2D

export (float) var nextSpawnTime = 5.0
export (float) var minSpawnRate = 1.0
export (int) var maxEnemySpawn = 5
export (bool) var changeSpawnRate = false 


var enemies = []
var preloadedEnemies = [
	preload("res://src/actors/Enemies/FastEnemy/FastEnemy.tscn"),
	preload("res://src/actors/Enemies/ShooterEnemy/ShooterEnemy.tscn")
]

onready var battleEnemy = preload("res://src/actors/Enemies/BattleEnemy/BattleEnemy.tscn")

onready var counter = 1

onready var spawnTimer = $SpawnTimer
onready var pos = $Position2D

onready var mc_instance = get_tree().current_scene.get_node("MC")

onready var difficultCoef = 1.0

onready var viewportRect = get_viewport_rect()

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)
	
func _on_SpawnTimer_timeout():
	var currentScore = get_tree().current_scene.points
	
	if get_tree().get_nodes_in_group("enemy").size() < maxEnemySpawn:
		
		# Создание врага
		var preloadedEnemy = preloadedEnemies[randi() % preloadedEnemies.size()]
		var enemy = preloadedEnemy.instance()

		if preloadedEnemy == preloadedEnemies[0]:
			createFastEnemy(enemy)

		if preloadedEnemy == preloadedEnemies[1]:
			createShooterEnemy(enemy)

		if  currentScore > 10000 and not battleEnemy in preloadedEnemies:
			preloadedEnemies.append(battleEnemy)
			 
		if preloadedEnemy == battleEnemy \
		and get_tree().get_nodes_in_group("BattleEnemy").size() < maxEnemySpawn / counter:
			createBattleEnemy(enemy)
			
		if changeSpawnRate:
			if nextSpawnTime > minSpawnRate:
				nextSpawnTime -= 0.05 
				
		increaseMaxEnemySpawn(currentScore)
				
		# Рестарт таймера
		spawnTimer.start(nextSpawnTime)
	else:
		spawnTimer.start(nextSpawnTime)
		
		
func increaseMaxEnemySpawn(score):
	if score / 2500.0 > counter:
			counter += 1
			if mc_instance.mcDamage / difficultCoef >= 2:
				difficultCoef += 1
			
			if counter % 2 == 0:
				maxEnemySpawn += counter


func createBattleEnemy(enemy):
	var enemyVerticalSpeed = enemy.verticalSpeed
	enemy.verticalSpeed = rand_range(enemyVerticalSpeed - 20, enemyVerticalSpeed + 20)	

	var enemyHorisontalSpeed = enemy.horisontalSpeed
	enemy.horisontalSpeed = rand_range(enemyHorisontalSpeed - 5, enemyHorisontalSpeed + 50)
	
	
	enemy.coef = difficultCoef - 4
	enemy.global_position = Vector2(pos.global_position.x + 50, rand_range(50, viewportRect.end.y - 50))
	get_tree().current_scene.add_child(enemy)


func createShooterEnemy(enemy):
	var enemyVerticalSpeed = enemy.verticalSpeed
	enemy.verticalSpeed = rand_range(enemyVerticalSpeed - 20, enemyVerticalSpeed + 50)	
	
	var enemyHorisontalSpeed = enemy.horisontalSpeed
	enemy.horisontalSpeed = rand_range(enemyHorisontalSpeed - 5, enemyHorisontalSpeed + 50)
	enemy.coef = difficultCoef
	
	enemy.global_position = Vector2(pos.global_position.x, rand_range(25, viewportRect.end.y - 25))
	get_tree().current_scene.add_child(enemy)


func createFastEnemy(enemy):
	var crntSpeed = enemy.horisontalSpeed
	var playerPos = get_tree().current_scene.get_node("MC").position.y
	
	enemy.horisontalSpeed = rand_range(crntSpeed - crntSpeed * 0.1, crntSpeed + crntSpeed * 0.2)
	enemy.coef = difficultCoef
	
	enemy.global_position = Vector2(pos.global_position.x, playerPos)			
	get_tree().current_scene.add_child(enemy)
