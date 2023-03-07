extends KinematicBody2D

export (float) var horisontalSpeed = 100.0 # cкорость полета корабля
export (float) var verticalSpeed = 200.0 # cкорость вертикального движения корабля


var mcMotion = Vector2() # вектор скорости
var viewportSize : Vector2


func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а

func _process(delta) -> void:
	spaceshipMove(delta) # функция движения корабля
	
	
func spaceshipMove(delta) -> void:
		
	var inputVector = Vector2.ZERO # Обнуление координат вектора скоростей
	
	if Input.is_action_pressed("ui_up"): # Зажатие стрелки вверх или W
		inputVector.y -= 1
	
	if Input.is_action_pressed("ui_down"): # Зажатие стрелки вниз или S
		inputVector.y += 1
	
	
	if inputVector.length() > 0: # Если есть движение корабля
		inputVector = inputVector.normalized() * verticalSpeed
		
	
	position.y += inputVector.y * delta 
	# delta позволяет естественно набирать скорость (не моментально)	
	position.x += horisontalSpeed * delta
	position.y = clamp(position.y, 0, viewportSize.y) 
		
	mcMotion = move_and_slide(inputVector)








