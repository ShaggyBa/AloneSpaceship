extends CanvasLayer


onready var current_scene = get_parent()
onready var mc_instance = current_scene.get_node("MC")

onready var start_mc_Speed = (mc_instance.mcSpeed + mc_instance.mcVSpeed) / 2
onready var mc_start_shoot_delay = mc_instance.mcShootSpeed


onready var score_counter = $HUD/HBoxContainer/VBoxContainer/ScoreCounter
onready var health_counter = $HUD/HBoxContainer/VBoxContainer/HealthCounter

onready var damage_counter = $PauseMenu/CenterContainer2/HUD/DamageCounter
onready var speed_counter = $PauseMenu/CenterContainer2/HUD/SpeedCounter
onready var shoot_speed_counter = $PauseMenu/CenterContainer2/HUD/ShootSpeedCounter


var current_mc_hp
var current_mc_speed
var current_mc_shoot_speed
var current_mc_damage
var current_score

func _ready() -> void:
	get_stats()
	set_stats()
	

func _process(_delta: float) -> void:
	current_score = current_scene.points		
	score_counter.set_points(current_score)

	if current_mc_hp != mc_instance.mcHP or \
	 current_mc_speed != stepify((mc_instance.mcSpeed + mc_instance.mcVSpeed) / 2 / start_mc_Speed, 0.01) or \
	 current_mc_shoot_speed != stepify(mc_start_shoot_delay / mc_instance.mcShootSpeed, 0.01) or \
	 current_mc_damage != mc_instance.mcDamage:
		
		get_stats()
		set_stats()


func get_stats():
	current_mc_hp = mc_instance.mcHP
	current_mc_speed = stepify((mc_instance.mcSpeed + mc_instance.mcVSpeed) / 2 / start_mc_Speed, 0.01)
	current_mc_shoot_speed = stepify(mc_start_shoot_delay / mc_instance.mcShootSpeed, 0.01)
	current_mc_damage = mc_instance.mcDamage
	
func set_stats():
	health_counter.set_points(current_mc_hp)
	damage_counter.set_points(current_mc_damage)
	speed_counter.set_points(current_mc_speed)
	shoot_speed_counter.set_points(current_mc_shoot_speed)
