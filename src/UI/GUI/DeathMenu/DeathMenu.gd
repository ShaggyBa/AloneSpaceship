extends Control

@onready var score_counter = $CenterContainer/VBoxContainer/HBoxContainer/ScoreCounter
@onready var high_score_counter = $CenterContainer/VBoxContainer/HBoxContainer2/HighScoreCounter

signal game_is_over()

var is_paused = false: set = set_is_over
var main_menu = "res://src/UI/MainMenu/Menu.tscn"



func _on_TryBtn_pressed()->void:
	queue_free()
	get_tree().reload_current_scene()


func _on_QuitBtn_pressed()->void:
	get_tree().change_scene_to_file(main_menu)


func _unhandled_input(event):
	if event.is_action_pressed("over"):
		self.is_paused = !is_paused


func set_is_over(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	update_score()

func update_score():
	var current_score := int(Main.points)
	var high_score := int(SaveFile.game_data.get("score", 0))

	if current_score > high_score:
		high_score = current_score
		SaveFile.game_data["score"] = high_score
		SaveFile.save_data()

	score_counter.set_points(current_score)
	high_score_counter.set_points(high_score)
