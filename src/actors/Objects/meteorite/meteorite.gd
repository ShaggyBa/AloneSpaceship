extends KinematicBody2D


export (float) var speed = 100.0

var motion = Vector2()

func _process(delta):
	var inputVector = Vector2()
	inputVector.x -= speed # метеорит летит на игрока в левую часть экрана (-х)
	
	motion = move_and_slide(inputVector)
