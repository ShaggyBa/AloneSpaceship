extends CanvasLayer


onready var pause_button := $Control/HBoxContainer/PauseBtn2

onready var joy_stick := $Control/TouchScreenButton
onready var inner_circle := $Control/InnerCircle

onready var health_counter := $Control/HBoxContainer/VBoxContainer4/HealthCounter
onready var score_counter := $Control/HBoxContainer/VBoxContainer4/ScoreCounter

onready var kills_counter := $PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer6/KillsCounter
onready var damage_counter := $PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer6/DamageCounter
onready var rpm_counter := $PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer2/RPMCounter
onready var speed_counter := $PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer2/SpeedCounter

onready var kills_counterD := $DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer6/KillsCounter
onready var damage_counterD := $DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer6/DamageCounter
onready var rpm_counterD := $DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer2/RPMCounter
onready var speed_counterD := $DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer2/SpeedCounter
onready var final_score := $DeathMenu/CenterContainer/VBoxContainer/CenterContainer/ScoreCounter


var move_vector = Vector2(0,0)
var joystick_active = false
var previous_x = 0

var enemy_death_points = 100
var kills = 0

var down = [] 
var joy_event_index = 0

signal change_move(new_move)


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if joy_stick.is_pressed():
			if event.position.x < 800:
				move_vector = calculate_move_vector(event.position)
				inner_circle.position = event.position
				inner_circle.visible = true
				emit_signal("change_move",Vector2(move_vector.x, move_vector.y) )
	
	if event is InputEventScreenTouch:
		if event.pressed == false:
			inner_circle.visible = false
			emit_signal("change_move",Vector2(0,0))


func  calculate_move_vector(event_position):
	var texture_center = joy_stick.position + Vector2(64,64)
	return (event_position - texture_center).normalized()


func _on_MC_health_changed(new_value):
	health_counter.set_points(floor(new_value))


func _unhandled_input(event):
	if event.is_action_pressed("enemy_death"):
		kills += 1
		kills_counter.set_points(kills)
		kills_counterD.set_points(kills)
		score_counter.increase_points_on(enemy_death_points)
	
	
func _on_MC_damage_changed(new_value):
	damage_counter.set_points(new_value)
	damage_counterD.set_points(new_value)


func _on_MC_shootDelay_changed(new_value):
	rpm_counter.set_points(new_value)
	rpm_counterD.set_points(new_value)


func _on_MC_speed_changed(new_value):
	speed_counter.set_points(new_value)
	speed_counterD.set_points(new_value)


func _on_DeathMenu_game_is_over():
	pass
	final_score.set_points(score_counter.get_points())
	#print("game over")
