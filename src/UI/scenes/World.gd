extends Node

var points := 0.0

onready var counter := $CanvasLayer/Interface/Counter2
onready var counter_final := $CanvasLayer/DeathMenu/CenterContainer/VBoxContainer/CenterContainer/Counter2

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	#$MeteoriteSpawner.global_position.x += $MC.mcSpeed * delta
	#$EnemySpawner.global_position.x += $MC.mcSpeed * delta
	points += delta * 100000
	counter.set_points(floor(points))
	counter_final.set_points(floor(points))
	



func _on_Button_pressed():
	get_tree().change_scene("res://src/scenes/World_2.tscn")
