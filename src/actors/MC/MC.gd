extends Area2D
class_name MC


export (float) var mcSpeed = 200.0 # cкорость полета корабля
export (float) var mcVSpeed = 300.0 # cкорость вертикального движения корабля
export (int) var mcHP = 3
export (float) var shootDelay = 1.0


signal spawnShoot(location)


onready var muzzle = $Muzzle


var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2
var canShoot = true
var timer = Timer.new()


func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а
	# Создание таймера для стрельбы
	timer.set_one_shot(true)
	timer.set_wait_time(shootDelay)
	timer.connect("timeout", self, "onTimeoutComplete")
	add_child(timer)
	
	
func _physics_process(delta) -> void:
	spaceshipMove(delta) # функция движения корабля
	
	if Input.is_action_pressed("ui_accept") && canShoot == true:
		shoot()
		canShoot = false
		timer.start()
	
func spaceshipMove(delta) -> void:
		
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector.x = 1 
	
	global_position.x += inputVector.x * mcSpeed * delta 
	global_position.y += inputVector.y * mcVSpeed * delta 
	
	global_position.y = clamp(position.y, 0, viewportSize.y) 


func takeDamage(damage):
	mcHP -= damage
	if mcHP <= 0:
		queue_free()
		get_tree().reload_current_scene()


func _on_MC_area_entered(area: Area2D) -> void:
	if area.is_in_group("meteorites"):
		area.takeDamage(1)


func shoot():
	emit_signal("spawnShoot", muzzle.global_position)


func onTimeoutComplete():
	canShoot = true
