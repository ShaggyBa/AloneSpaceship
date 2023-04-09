extends Node

var points := 0.0
var multiscore = 1.0
var dec = 1

onready var music = $Music

onready var counter := $GUI/Control/HBoxContainer/VBoxContainer4/ScoreCounter
onready var counter_final := $GUI/DeathMenu/CenterContainer/VBoxContainer/HBoxContainer/ScoreCounter

var newBack = preload("res://src/scenes/orangeLevel.tscn")
var orangeInst

func _ready() -> void:
	music.play()


func _process(delta: float) -> void:
	if points / 1000 > dec:
		dec += 1
		multiscore += 0.05
		
	
	points += delta * 100 * multiscore
	counter.set_points(floor(points))
	counter_final.set_points(floor(points))
	if points > 10000:
		changeBack() 
	

func changeBack():
	orangeInst = newBack.instance()
	add_child(orangeInst)
	$blueLevel.queue_free()
		
