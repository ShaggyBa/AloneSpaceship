extends Node


@export (float) var multiscore = 1.0
@export (float) var pointsToSpawnBoss = 100000.0



@onready var music = $Music
@onready var mc_instance = $MC
@onready var enemySpawner = $EnemySpawner

@onready var plBoss = preload("res://src/actors/Boss/Boss.tscn")
@onready var newBack = preload("res://src/scenes/orangeLevel.tscn")


var orangeInst
var bossIsSpawning = false
var bossIsDefeating = false

var dec = 1
var points := 0.0

var currentMultiscore
var currentCountOfEnemies 

func _ready() -> void:
	music.play()
	


func _process(delta: float) -> void:
	if points / 1000 > dec and not bossIsSpawning:
		dec += 1
		multiscore += 0.05
	

	points += delta * 100 * multiscore
	
	
	if points >= pointsToSpawnBoss and not bossIsSpawning:
		var boss = plBoss.instantiate()
		boss.global_position = Vector2(1100, 300)
		boss.connect("boss_defeated", Callable(self, "_onBossDefeated"))
		
		add_child(boss)
		
		currentMultiscore = multiscore
		multiscore = 0.0
		
		currentCountOfEnemies = enemySpawner.maxEnemySpawn
		enemySpawner.maxEnemySpawn = 0
		
		bossIsSpawning = true



func _onBossDefeated():
	multiscore = currentMultiscore
	bossIsDefeating = true
	changeLevel()


func changeLevel():
	orangeInst = newBack.instantiate()
	add_child(orangeInst)
	$blueLevel.queue_free()	
	enemySpawner.maxEnemySpawn = currentCountOfEnemies
	


func _on_Music_finished() -> void:
	if not mc_instance.isDead:	
		await get_tree().create_timer(10).timeout
		music.play()
