extends Node

var points := 0.0

onready var music = $Music

onready var counter := $CanvasLayer/Control/HBoxContainer/VBoxContainer4/ScoreCounter
onready var counter_final := $CanvasLayer/DeathMenu/CenterContainer/VBoxContainer/CenterContainer/ScoreCounter

var newBack = preload("res://src/scenes/orangeLevel.tscn")
var orangeInst

func _ready() -> void:
	music.play()


func _process(delta: float) -> void:
	points += delta * 100
	counter.set_points(floor(points))
	counter_final.set_points(floor(points))
	if points > 150:
		changeBack()
	

func changeBack():
	orangeInst = newBack.instance()
	add_child(orangeInst)
	$blueLevel.queue_free()
		
