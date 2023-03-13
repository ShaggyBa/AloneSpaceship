extends Area2D
class_name MC


export (float) var mcSpeed = 200.0 # cкорость полета корабля
export (float) var mcVSpeed = 300.0 # cкорость вертикального движения корабля
export (int) var mcHP = 3
export (float) var shootDelay = 1.0
export (float) var invincibilityDelay = 0.3


var plShoot = preload("res://src/actors/Projectiles/MC_shoot.tscn") 


onready var muzzle = $Muzzle


var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2

var timerShooting = Timer.new()
var timerInvincibility = Timer.new()

func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а
	# Создание таймера для стрельбы
	setTimerShooting()
	setTimerInvincibility()
	
func _process(delta: float) -> void:
	shooting()
	# Эффект мерцания от полученного урона, пока нет спрайта щитка
	if !timerInvincibility.is_stopped():
		modulate.a = 0.5 if Engine.get_frames_drawn() % 2 == 0 else 1.0 
	else:
		modulate.a = 1
func _physics_process(delta) -> void:
	spaceshipMove(delta) # функция движения корабля
	
# Создание таймера
func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(shootDelay)
	add_child(timerShooting)
	
	
func setTimerInvincibility()->void:
	timerInvincibility.set_one_shot(true)
	timerInvincibility.set_wait_time(invincibilityDelay)
	add_child(timerInvincibility)

# Стрельба
func shooting():
	if Input.is_action_pressed("ui_accept") and timerShooting.is_stopped():
		timerShooting.start()		
		var shoot = plShoot.instance()
		shoot.global_position = $Muzzle.global_position
		get_tree().current_scene.add_child(shoot)
	
# Передвижение
func spaceshipMove(delta) -> void:
		
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector.x = 1 
	
	global_position.x += inputVector.x * mcSpeed * delta 
	global_position.y += inputVector.y * mcVSpeed * delta 
	global_position.y = clamp(position.y, 0, viewportSize.y) 

# Получение урона
func takeDamage(damage):
	if !timerInvincibility.is_stopped():
		return
	timerInvincibility.start()
	mcHP -= damage
	if mcHP <= 0:
		queue_free()
		get_tree().reload_current_scene()

# Столкновение с метеоритами
func _on_MC_area_entered(area: Area2D) -> void:
	if area.is_in_group("meteorites"):
		print("Spaceship take damage from meteorite")
		
