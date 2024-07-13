extends Control

@onready var game_data = SaveFile.game_data

@onready var current_scene = get_parent()


var is_paused = false: set = set_is_paused
var main_menu = "res://src/UI/MainMenu/Menu.tscn"



func _ready():
	self.is_paused = !is_paused
	self.is_paused = !is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if current_scene.mc_instance.isDead:
			return
		self.is_paused = !is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
		
#	update_score()
	visible = is_paused	


func _on_ResumeBtn_pressed():
	self.is_paused = false


func _on_QuitBtn_pressed()->void:
	get_tree().change_scene_to_file(main_menu)
	

func _on_PauseBtn_pressed():
	self.is_paused = !is_paused


func update_score():
	$CenterContainer/Menu/HighScoreCounter.text = str(game_data.score)


func _on_TryBtn_pressed()->void:
	queue_free()
	get_tree().reload_current_scene()
