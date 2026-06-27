extends Node

signal score_changed(score: float)
signal multiscore_changed(multiscore: float)


@export var multiscore: float = 1.0
@export var pointsToSpawnBoss: float = 100000.0



@onready var music = $Music
@onready var mc_instance = $MC
@onready var enemySpawner = $EnemySpawner

@onready var plBoss = preload("res://src/actors/Boss/Boss.tscn")
@onready var newBack = preload("res://src/scenes/orangeLevel.tscn")


var orangeInst
var bossIsSpawning = false
var bossIsDefeating = false

var dec = 1
var points = 0

var currentMultiscore
var currentCountOfEnemies 

func _ready() -> void:
	music.play()
	if not GameEvents.multiscore_bonus_requested.is_connected(_on_multiscore_bonus_requested):
		GameEvents.multiscore_bonus_requested.connect(_on_multiscore_bonus_requested)
	GameEvents.emit_multiscore_changed(multiscore)
	


func _process(delta: float) -> void:
	if points / 1000 > dec and not bossIsSpawning:
		dec += 1
		add_multiscore(0.05)
	

	points += delta * 100 * multiscore
	
	Main.points = points
	score_changed.emit(points)
	GameEvents.emit_score_changed(points)
	
	if points >= pointsToSpawnBoss and not bossIsSpawning:
		var boss = plBoss.instantiate()
		boss.global_position = Vector2(1100, 300)
		boss.connect("boss_defeated", Callable(self, "_onBossDefeated"))
		
		SpawnService.spawn(boss, self)
		
		currentMultiscore = multiscore
		set_multiscore(0.0)
		
		currentCountOfEnemies = enemySpawner.maxEnemySpawn
		enemySpawner.maxEnemySpawn = 0
		
		bossIsSpawning = true



func _onBossDefeated():
	set_multiscore(currentMultiscore)
	bossIsDefeating = true
	changeLevel()


func changeLevel():
	orangeInst = newBack.instantiate()
	SpawnService.spawn(orangeInst, self)
	$blueLevel.queue_free()	
	enemySpawner.maxEnemySpawn = currentCountOfEnemies
	


func _on_Music_finished() -> void:
	if not mc_instance.isDead:	
		await get_tree().create_timer(10).timeout
		music.play()


func set_multiscore(value: float) -> void:
	multiscore = value
	multiscore_changed.emit(multiscore)
	GameEvents.emit_multiscore_changed(multiscore)


func add_multiscore(value: float) -> void:
	set_multiscore(multiscore + value)


func _on_multiscore_bonus_requested(amount: float) -> void:
	add_multiscore(amount)
