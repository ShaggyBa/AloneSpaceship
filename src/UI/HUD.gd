extends CanvasLayer


onready var current_scene = get_parent()

onready var score_counter = $HUD/HBoxContainer/VBoxContainer/ScoreCounter
func _process(delta: float) -> void:
	score_counter.set_points(current_scene.points)
	
