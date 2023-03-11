extends Area2D
class_name MC


export (float) var mcSpeed = 200.0 # cкорость полета корабля
export (float) var mcVSpeed = 300.0 # cкорость вертикального движения корабля
export (int) var mcHP = 3
export (float) var shootDelay = 1.0


signal spawnShoot(location)


var plShoot = preload("res://src/actors/Projectiles/MC_shoot.tscn") 


onready var muzzle = $Muzzle


var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2
var timer = Timer.new()


func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а
	# Создание таймера для стрельбы
	set_timer()
	
	
func _process(delta: float) -> void:
	shooting()


func _physics_process(delta) -> void:
	spaceshipMove(delta) # функция движения корабля
	
# Создание таймера
func set_timer()->void:
	timer.set_one_shot(true)
	timer.set_wait_time(shootDelay)
	add_child(timer)
	
# Стрельба
func shooting():
	if Input.is_action_pressed("ui_accept") and timer.is_stopped():
		timer.start()		
		var shoot = plShoot.instance()
		shoot.global_position = $Muzzle.global_position
		get_tree().current_scene.add_child(shoot)
	
# Передвижение
func spaceshipMove(delta) -> void:
		
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector.x = 1 
	
	position.x += inputVector.x * mcSpeed * delta 
	position.y += inputVector.y * mcVSpeed * delta 
	
	position.y = clamp(position.y, 0, viewportSize.y) 

# Получение урона
func takeDamage(damage):
	mcHP -= damage
	if mcHP <= 0:
		queue_free()
		get_tree().reload_current_scene()

# Столкновение с метеоритами
func _on_MC_area_entered(area: Area2D) -> void:
	if area.is_in_group("meteorites"):
		area.takeDamage(1)
		print("Spaceship take damage from meteorite")
		
