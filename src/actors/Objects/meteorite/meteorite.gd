extends CharacterBody2D


@export var speed: float = 100.0

var motion = Vector2()

func _process(delta):
	var inputVector = Vector2()
	inputVector.x -= speed # метеорит летит на игрока в левую часть экрана (-х)
	
	velocity = inputVector
	move_and_slide()
	motion = velocity
