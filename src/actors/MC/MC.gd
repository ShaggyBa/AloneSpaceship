extends Area2D
class_name MC


export (float) var mcSpeed = 200.0 # cкорость полета корабля
export (float) var mcVSpeed = 300.0 # cкорость вертикального движения корабля
export (int) var mcHP = 5
export (float) var shootDelay = 1.0
export (float) var delayShieldRestoring = 0.3


var plShoot = preload("res://src/actors/Projectiles/BaseShoot.tscn")

var pFullHP = preload("res://src/Assets/Sprites/MainShip/model/FullHP.png")
var pSemiHP = preload("res://src/Assets/Sprites/MainShip/model/SemiHP.png")
var pLowHP = preload("res://src/Assets/Sprites/MainShip/model/LowHP.png")
var pVeryLowHP = preload("res://src/Assets/Sprites/MainShip/model/VeryLowHP.png")


onready var muzzle = $Muzzle
onready var shield = $Shield
onready var sprite = $MCSprite
onready var hitSound = $Hit
onready var shotSound = $ShotSound
onready var shieldHitSound = $ShieldHit
onready var engineSprite = $EngineSprite
onready var crushEffects = $CrushEffects

onready var maxHP = mcHP


var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2


var timerShooting = Timer.new()
var timerShieldRestoring = Timer.new()

var game_over = InputEventAction.new()



func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а
	# Создание таймера для стрельбы
	setTimerShooting()
	setTimerInvincibility()
	game_over.action = "over"
	game_over.pressed = true
	
	
func _process(delta: float) -> void:
	shooting()
	shieldEffect()
		
func _physics_process(delta) -> void:
	spaceshipMove(delta) # функция движения корабля
	
# Создание таймера
func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(shootDelay)
	add_child(timerShooting)
	
	
func setTimerInvincibility()->void:
	timerShieldRestoring.set_one_shot(true)
	timerShieldRestoring.set_wait_time(delayShieldRestoring)
	add_child(timerShieldRestoring)

# Стрельба
func shooting():
	if Input.is_action_pressed("ui_accept") and timerShooting.is_stopped():
		timerShooting.start()		
		var shoot = plShoot.instance()
		shoot.global_position = $Muzzle.global_position
		get_tree().current_scene.add_child(shoot)
		shotSound.play()
	
# Передвижение
func spaceshipMove(delta) -> void:
		
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector.x = 1 
	changeStateEngine(inputVector.y)
	global_position.x += inputVector.x * mcSpeed * delta 
	global_position.y += inputVector.y * mcVSpeed * delta 
	global_position.y = clamp(position.y, 0, viewportSize.y) 

# Получение урона
func takeDamage(damage):
	if timerShieldRestoring.is_stopped():
		shieldHitSound.play()
		timerShieldRestoring.start()
	else:
		mcHP -= damage
		changeState()	
		print("Текущий HP: ", mcHP)
		hitSound.play()
		if mcHP <= 0:
			Input.parse_input_event(game_over)
			#queue_free()
			#get_tree().reload_current_scene()

# эффект щита
func shieldEffect():
	if timerShieldRestoring.is_stopped():
		shield.visible = true
		shield.playing = true
	else:
		shield.visible = false
		shield.playing = false
		
func changeState():
	var MCCurrentState = float(mcHP) / float(maxHP)
	print(MCCurrentState)
	if MCCurrentState >= 0.8: 
		sprite.set_texture(pFullHP)
	elif MCCurrentState >= 0.6:
		sprite.set_texture(pSemiHP)
		crushEffects.emitting = true
	elif MCCurrentState >= 0.4:
		sprite.set_texture(pLowHP)
		crushEffects.amount = 10		
	elif MCCurrentState >= 0.2: 
		sprite.set_texture(pVeryLowHP)
		crushEffects.amount = 15				


func changeStateEngine(inputVector: int):
	if inputVector == 0:
		engineSprite.set_animation("idle")
	else:
		engineSprite.set_animation("powering")
	engineSprite.playing = true


func _on_MC_game_over():
	pass # Replace with function body.
