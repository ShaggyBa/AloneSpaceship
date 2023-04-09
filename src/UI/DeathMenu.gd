extends Control

func _on_TryBtn_pressed()->void:
	queue_free()
	get_tree().reload_current_scene()


func _on_QuitBtn_pressed()->void:
	get_tree().change_scene("res://src/UI/Menu.tscn")


var is_paused = false setget set_is_over

func _ready():
	self.is_paused = !is_paused
	self.is_paused = !is_paused

func _unhandled_input(event):
	if event.is_action_pressed("over"):
		self.is_paused = !is_paused


func set_is_over(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

