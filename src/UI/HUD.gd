extends CanvasLayer


onready var current_scene = get_parent()
onready var mc_instance = current_scene.get_node("MC")


onready var score_counter = $HUD/HBoxContainer/VBoxContainer/ScoreCounter
onready var health_counter = $HUD/HBoxContainer/VBoxContainer/HealthCounter


var current_mc_hp


func _ready() -> void:
	current_mc_hp = mc_instance.mcHP
	health_counter.set_points(current_mc_hp)


func _process(delta: float) -> void:
	score_counter.set_points(current_scene.points)

	if current_mc_hp != mc_instance.mcHP:
		current_mc_hp = mc_instance.mcHP		
		health_counter.set_points(current_mc_hp)
