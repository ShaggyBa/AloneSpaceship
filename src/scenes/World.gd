extends Node

var points := 0.0
export (float) var multiscore = 1.0
var dec = 1

onready var music = $Music

onready var counter := $GUI/Control/HBoxContainer/VBoxContainer4/ScoreCounter
onready var counter_final := $GUI/DeathMenu/CenterContainer/VBoxContainer/HBoxContainer/ScoreCounter

#var ScoreCounter
#var ScoreCounterF

onready var plBoss = preload("res://src/actors/Boss/Boss.tscn")
onready var newBack = preload("res://src/scenes/orangeLevel.tscn")

var orangeInst
var bossIsSpawning = false


func _ready() -> void:
	music.play()
#	ScoreCounter = get_tree().current_scene.get_node("GUI/Control/HBoxContainer/VBoxContainer4/ScoreCounter")
#	ScoreCounterF = get_tree().current_scene.get_node("GUI/DeathMenu/CenterContainer/VBoxContainer/HBoxContainer/ScoreCounter")



func _process(delta: float) -> void:
	if points / 1000 > dec:
		dec += 1
		multiscore += 0.05
		
	
	points += delta * 100 * multiscore
	counter.increase_points_on(floor(delta * 100 * multiscore))
	counter_final.set_points(counter.get_points())
#	counter.set_points(floor(points))
#	counter_final.set_points(counter.get_points())
	
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
		
