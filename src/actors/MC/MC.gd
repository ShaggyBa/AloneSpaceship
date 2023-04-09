extends Area2D
class_name MC


export (float) var mcSpeed = 200.0 # cкорость полета корабля
export (float) var mcVSpeed = 300.0 # cкорость вертикального движения корабля

export (int) var mcHP = 5


export (float) var shootDelay = 1.0
export (int) var mcDamage = 1

export (float) var delayShieldRestoring = 0.3
export (float) var duringShieldBonus = 2


var plShoot = preload("res://src/actors/Projectiles/BaseShoot.tscn")

var pFullHP = preload("res://src/Assets/Sprites/MainShip/model/FullHP.png")
var pSemiHP = preload("res://src/Assets/Sprites/MainShip/model/SemiHP.png")
var pLowHP = preload("res://src/Assets/Sprites/MainShip/model/LowHP.png")
var pVeryLowHP = preload("res://src/Assets/Sprites/MainShip/model/VeryLowHP.png")


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
var isInvicibility = false

var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2


var timerShooting = Timer.new()
var timerShieldRestoring = Timer.new()
var timerDuringShieldBonus = Timer.new()

var game_over = InputEventAction.new()

signal health_changed(new_value)
signal damage_changed(new_value)
signal shootDelay_changed(new_value)
signal speed_changed(new_value)


func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а

	setTimerShooting()
	setTimerInvincibility()
	setTimerShieldBonus()
	
	game_over.action = "over"
	game_over.pressed = true
		
	emit_signal("health_changed", mcHP)
	emit_signal("damage_changed", mcDamage)
	emit_signal("shootDelay_changed", round(1 / shootDelay))
	emit_signal("speed_changed", mcSpeed)
	
func _process(delta: float) -> void:
	shooting()
	shieldEffect()
	
	
func _physics_process(delta) -> void:
	spaceshipMove(delta)
	
	
func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(shootDelay)
	add_child(timerShooting)
	
	
func setTimerInvincibility()->void:
	timerShieldRestoring.set_one_shot(true)
	timerShieldRestoring.set_wait_time(delayShieldRestoring)
	add_child(timerShieldRestoring)
	
	
func setTimerShieldBonus()->void:
	timerDuringShieldBonus.set_one_shot(true)
	add_child(timerDuringShieldBonus)
	timerDuringShieldBonus.connect("timeout", self, "disabledShieldBonus")


func shooting():
	if Input.is_action_pressed("ui_accept") and timerShooting.is_stopped():
		timerShooting.start()		
		create_shoot()
		
	
func create_shoot():
	var shoot = plShoot.instance()
	shoot.global_position = muzzle.global_position
	shoot.damage = mcDamage
	get_tree().current_scene.add_child(shoot)
	shotSound.play()


func spaceshipMove(delta):
#	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	changeStateEngine(inputVector)
	changePosition(inputVector, delta)
	

func changePosition(vector:Vector2, delta:float):
	global_position.x += vector.x * mcSpeed * delta
	global_position.y += vector.y * mcVSpeed * delta 
	global_position.y = clamp(global_position.y, 50, viewportSize.y - 50)
	global_position.x = clamp(global_position.x, 50, viewportSize.x - 50) 
	 

# Получение урона
func takeDamage(damage):
	if isInvicibility: 
		return
	else:	
		if timerShieldRestoring.is_stopped():
			shieldHitSound.play()
			yield(get_tree().create_timer(0.15), "timeout")
			timerShieldRestoring.start()
		else:
			mcHP -= damage
			
			changeState()			
			
#			print("Текущий HP: ", mcHP)
			
			emit_signal("health_changed", mcHP)
			
			hitSound.play()
			
			if mcHP <= 0:
				Input.parse_input_event(game_over)

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
	if MCCurrentState >= 0.8: 
		crushEffects.emitting = false		
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


func changeStateEngine(vector: Vector2):
	if vector.x == 0 and vector.y == 0:
		engineSprite.set_animation("idle")
	else:
		engineSprite.set_animation("powering")
	engineSprite.playing = true 
	

func _on_CanvasLayer_change_move(new_move: Vector2):
	inputVector = new_move


func _on_MC_area_entered(area):
	if area.is_in_group("Heal"):
		heal()
	elif area.is_in_group("ShieldBonus"):
		timerShieldBonus()
	elif area.is_in_group("addDamage"):
		addPassiveDamageBonus()
	elif area.is_in_group("addShootSpeed"):
		addPassiveShootSpeedBonus()
		
		
func heal():
	if mcHP + 5 < maxHP:
		mcHP += 5
	else:
		mcHP = maxHP
	emit_signal("health_changed", mcHP)	
	changeState()
	
		
func timerShieldBonus():
	timerDuringShieldBonus.start(duringShieldBonus)
	shieldBonus()
	
	
func shieldBonus():
	isInvicibility = true
	timerShieldRestoring.stop()
	shield.animation = "invincibility"


func disabledShieldBonus():
	isInvicibility = false
	shield.animation = "autoshield"
	

func addPassiveDamageBonus():
	mcDamage += 1
	
	
func addPassiveShootSpeedBonus():
	emit_signal("damage_changed", mcDamage)
	if shootDelay > 0.1:
		shootDelay -= 0.05 
	timerShooting.set_wait_time(shootDelay)
	
func shootDelayBonus():
	emit_signal("shootDelay_changed", shootDelay)

func speedBonus():
	emit_signal("speed_changed", mcVSpeed)
