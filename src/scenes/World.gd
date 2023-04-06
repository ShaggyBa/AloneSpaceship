extends Node

var points := 0.0

onready var counter := $CanvasLayer/Control/HBoxContainer/VBoxContainer4/ScoreCounter
onready var counter_final := $CanvasLayer/DeathMenu/CenterContainer/VBoxContainer/CenterContainer/ScoreCounter



func _ready() -> void:
	$Music.play()


func _process(delta: float) -> void:
	points += delta * 100
	counter.set_points(floor(points))
	counter_final.set_points(floor(points))


func _on_Button_pressed():
	get_tree().change_scene("res://src/scenes/World_2.tscn")
