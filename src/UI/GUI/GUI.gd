extends CanvasLayer


@onready var pause_button := $Control/HBoxContainer/PauseBtn2

@onready var joy_stick := $Control/TouchScreenButton
@onready var inner_circle := $Control/InnerCircle


var move_vector = Vector2(0,0)
var joystick_active = false
var previous_x = 0

var enemy_death_points = 100
var kills = 0

var joy_event_index = 0

signal change_move(new_move)

func _ready():
	pass

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if joy_stick.is_pressed():
			if event.position.x < 800:
				move_vector = calculate_move_vector(event.position)
				inner_circle.position = event.position
				inner_circle.visible = true
				emit_signal("change_move",Vector2(move_vector.x, move_vector.y) )
	
	if event is InputEventScreenTouch:
		if event.button_pressed == false:
			inner_circle.visible = false
			emit_signal("change_move",Vector2(0,0))


func  calculate_move_vector(event_position):
	var texture_center = joy_stick.position + Vector2(64,64)
	return (event_position - texture_center).normalized()
