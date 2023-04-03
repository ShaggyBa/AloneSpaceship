extends CanvasLayer

signal use_move_vector

var move_up = InputEventAction.new()
var move_down = InputEventAction.new()
var move_right = InputEventAction.new()
var move_left = InputEventAction.new()

var move_vector = Vector2(0,0)
var joystick_active = false

func _ready()->void:
	move_up.action = "ui_up"
	move_up.pressed = true
	
	move_down.action = "ui_down"
	move_down.pressed = true
	
	move_right.action = "ui_right"
	move_right.pressed = true
	
	move_left.action = "ui_left"
	move_left.pressed = true

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $Interface/TouchScreenButton.is_pressed():
			var move_vector = calculate_move_vector(event.position)
			joystick_active = true
			#print(move_vector)
			$Interface/InnerCircle.position = event.position
			$Interface/InnerCircle.visible = true
			print(move_vector)
#			if move_vector.x > 0:
#				move_up.pressed = true
#				Input.parse_input_event(move_right)
#
#			if move_vector.x < 0:
#				move_down.pressed = true
#				Input.parse_input_event(move_left)
#
#			if move_vector.y > 0:
#				move_right.pressed = true
#				Input.parse_input_event(move_up)
#
#			if move_vector.y < 0:
#				move_left.pressed = true
#				Input.parse_input_event(move_down)
			

	if event is InputEventScreenTouch:
		if event.pressed == false:
			joystick_active = false	
			$Interface/InnerCircle.visible = false
			move_up.pressed = false
			Input.parse_input_event(move_right)
			move_down.pressed = false
			Input.parse_input_event(move_left)
			move_right.pressed = false
			Input.parse_input_event(move_up)
			move_left.pressed = false
			Input.parse_input_event(move_down)
			


func _physics_process(_delta):
	if joystick_active:
		pass
		

func  calculate_move_vector(event_position):
	var texture_center = $Interface/TouchScreenButton.position + Vector2(32,32)
	return (event_position - texture_center).normalized()

