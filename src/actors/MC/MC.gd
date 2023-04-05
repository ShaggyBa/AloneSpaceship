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

onready var BS = load("res://src/actors/Objects/Bonuses/BonusShield/ShieldBonus.tscn")
onready var muzzle = $Muzzle
onready var shield = $Shield
#onready var bonusShield = $Shield
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

signal health_changed(new_value) 


func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а
	# Создание таймера для стрельбы
	setTimerShooting()
	setTimerInvincibility()
	var bonusMode = BS.instance()
	bonusMode.connect("bonusEntered", self, "doWhat")
	
	game_over.action = "over"
	game_over.pressed = true
		
	emit_signal("health_changed", mcHP)
	
	
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
		create_shoot()
		
	
func create_shoot():
	var shoot = plShoot.instance()
	shoot.global_position = $Muzzle.global_position
	get_tree().current_scene.add_child(shoot)
	shotSound.play()

# Передвижение
func spaceshipMove(delta):
		
	#inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	changeStateEngine(inputVector)
	changeVectorPosition(inputVector, delta)
	

func changeVectorPosition(inputVector, delta):
	global_position.x += inputVector.x * mcSpeed * delta
	global_position.y += inputVector.y * mcVSpeed * delta 
	global_position.y = clamp(global_position.y, 50, viewportSize.y - 50)
	global_position.x = clamp(global_position.x, 50, viewportSize.x - 50) 
	 

# Получение урона
func takeDamage(damage):
	if timerShieldRestoring.is_stopped():
		shieldHitSound.play()
		yield(get_tree().create_timer(0.15), "timeout")
		timerShieldRestoring.start()
	else:
		mcHP -= damage
		changeState()			
		print("Текущий HP: ", mcHP)
		emit_signal("health_changed", mcHP)
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
		
		
func BonusShieldEffect():
	var sceneBonusShield = preload("res://src/actors/Objects/Bonuses/BonusShield/ShieldBonus.tscn")
	var bonusShield = sceneBonusShield.instance()
	add_child(bonusShield)
	
	#bonusShield.emit_signal(sayHello)
		
		
func changeState():
	var MCCurrentState = float(mcHP) / float(maxHP)
	if MCCurrentState >= 0.8: 
		sprite.set_texture(pFullHP)
	elif MCCurrentState >= 0.6:
		crushEffects.emitting = true			
		sprite.set_texture(pSemiHP)
	elif MCCurrentState >= 0.4:
		crushEffects.emitting = true					
		sprite.set_texture(pLowHP)
		crushEffects.amount = 10		
	else: 
		crushEffects.emitting = true	
		sprite.set_texture(pVeryLowHP)
		crushEffects.amount = 15


func changeStateEngine(inputVector: Vector2):
	if inputVector.x == 0 and inputVector.y == 0:
		engineSprite.set_animation("idle")
	else:
		engineSprite.set_animation("powering")
	engineSprite.playing = true 
	

func _on_CanvasLayer_change_move(new_move):
	inputVector = new_move
