extends Node

var points := 0.0
export (float) var multiscore = 1.0
var dec = 1

onready var music = $Music

onready var counter := $GUI/Control/HBoxContainer/VBoxContainer4/ScoreCounter
onready var counter_final := $GUI/DeathMenu/CenterContainer/VBoxContainer/HBoxContainer/ScoreCounter

onready var plBoss = preload("res://src/actors/Boss/Boss.tscn")
onready var newBack = preload("res://src/scenes/orangeLevel.tscn")

var orangeInst
var bossIsSpawning = false


func _ready() -> void:
	music.play()
	


func _process(delta: float) -> void:
	if points / 1000 > dec:
		dec += 1
		multiscore += 0.05
		
	
	points += delta * 100 * multiscore
	counter_final.set_points(points)
	
	
	if points > 100000 and not bossIsSpawning:
		var boss = plBoss.instance()
		boss.global_position = Vector2(1100, 300)
		add_child(boss)
		bossIsSpawning = true

	if points > 100000 and get_tree().get_nodes_in_group("boss").size() == 0:
		changeBack() 

func changeBack():
	orangeInst = newBack.instance()
	add_child(orangeInst)
	$blueLevel.queue_free()
		


func _on_Music_finished() -> void:
	yield(get_tree().create_timer(10), "timeout")
	music.play()
