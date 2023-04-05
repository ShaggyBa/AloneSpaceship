extends CanvasLayer


onready var pause_button := $Control/HBoxContainer/PauseBtn2
onready var joy_stick := $Control/TouchScreenButton
onready var inner_circle := $Control/InnerCircle
onready var health_counter := $Control/HBoxContainer/VBoxContainer4/HealthCounter

var move_vector = Vector2(0,0)
var joystick_active = false
var previous_x = 0

signal change_move(new_move)


func _ready()->void:
	pass

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if joy_stick.is_pressed():
			
			if event.position.x > 450:
				move_vector = calculate_move_vector(Vector2(previous_x, event.position.y))
				print(Vector2(previous_x, event.position.y))
			else:
				move_vector = calculate_move_vector(event.position)
			
			previous_x = event.position.x
				
			joystick_active = true
			inner_circle.position = event.position
			inner_circle.visible = true
			#print(Vector2(round(move_vector.x), round(move_vector.y)))
			# Выбрать какой лучше ниже
			emit_signal("change_move",Vector2(round(move_vector.x), round(move_vector.y)) )
			#emit_signal("change_move",move_vector)
			

	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false	
			inner_circle.visible = false
			emit_signal("change_move",Vector2(0,0))
			


func _physics_process(_delta):
	if joystick_active:
		pass
		

func  calculate_move_vector(event_position):
	var texture_center = joy_stick.position + Vector2(64,64)
	return (event_position - texture_center).normalized()



func _on_MC_health_changed(new_value):
	health_counter.set_points(floor(new_value))


