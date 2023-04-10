extends Area2D
class_name MC


export (float) var mcSpeed = 200.0 # cкорость полета корабля
export (float) var mcVSpeed = 300.0 # cкорость вертикального движения корабля

export (int) var mcHP = 5



export (float) var shootDelay = 0.3
export (float) var bonusShootDelay = 0.2

export (int) var mcDamage = 1

export (float) var delayShieldRestoring = 0.3

export (float) var duringShieldBonus = 2.0
export (float) var duringDamageBonus = 5.0


var plShoot = preload("res://src/actors/Projectiles/BaseShoot/BaseShoot.tscn")
var shootBonus = preload("res://src/actors/Projectiles/BonusShoot/ShootBonus.tscn")

var pFullHP = preload("res://src/Assets/Sprites/MainShip/model/States/FullHP.png")
var pSemiHP = preload("res://src/Assets/Sprites/MainShip/model/States/SemiHP.png")
var pLowHP = preload("res://src/Assets/Sprites/MainShip/model/States/LowHP.png")
var pVeryLowHP = preload("res://src/Assets/Sprites/MainShip/model/States/VeryLowHP.png")


onready var muzzle = $Muzzle
onready var shield = $Shield
onready var sprite = $MCSprite
onready var engineSprite = $EngineSprite
onready var crushEffects = $CrushEffects
onready var collision = $CollisionShape2D

onready var hitSound = $Audio/Hit
onready var shotSound = $Audio/ShotSound
onready var shieldHitSound = $Audio/ShieldHit
onready var gameOverSound = $Audio/ShieldHit
onready var destroyed = $Audio/Destroyed

onready var maxHP = mcHP

var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2


var timerShooting = Timer.new()
var timerBonusShooting = Timer.new()
var timerShieldRestoring = Timer.new()
var timerDuringShieldBonus = Timer.new()
var timerDuringDamageBonus = Timer.new()


var tickRateDamage = Timer.new()

var game_over = InputEventAction.new()


var isInvicibility = false
var isDamageUp = false
var isDead = false

var HealthCounter
var RPSCounter
var SpeedCounter
var DamageCounter
var RPSCounterP
var SpeedCounterP
var DamageCounterP
var DeathMenu

func _ready() -> void:
	viewportSize = get_viewport().size # Получение размеров viewport-а

	setTimerShooting()
	setTimerBonusShooting()
	setTimerInvincibility()
	setTimerShieldBonus()
	setTimerDamageBonus()
	
	setTickRateDamage()
	
	game_over.action = "over"
	game_over.pressed = true
		
	stat_inizialization()	
	
	
func _process(_delta: float) -> void:
	shooting()
	shieldEffect()
	
	
func _physics_process(delta) -> void:
	spaceshipMove(delta)
	
	
func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(shootDelay)
	add_child(timerShooting)
	
func setTimerBonusShooting()->void:
	timerBonusShooting.set_one_shot(true)
	timerBonusShooting.set_wait_time(bonusShootDelay)
	add_child(timerBonusShooting)
	
func setTimerInvincibility()->void:
	timerShieldRestoring.set_one_shot(true)
	timerShieldRestoring.set_wait_time(delayShieldRestoring)
	add_child(timerShieldRestoring)
	
	
func setTimerShieldBonus()->void:
	timerDuringShieldBonus.set_one_shot(true)
	add_child(timerDuringShieldBonus)
	timerDuringShieldBonus.connect("timeout", self, "disabledShieldBonus")
	
func setTimerDamageBonus()->void:
	timerDuringDamageBonus.set_one_shot(true)
	add_child(timerDuringDamageBonus)
	timerDuringDamageBonus.connect("timeout", self, "disabledDamageBonus")


func setTickRateDamage()->void:
	tickRateDamage.set_one_shot(true)
	tickRateDamage.set_wait_time(1.0)
	tickRateDamage.connect("timeout", self, "_on_tickRateDamage_timeout")
	add_child(tickRateDamage)
	

func shooting():
	if (Input.is_action_pressed("ui_accept")) and (timerShooting.is_stopped() and timerBonusShooting.is_stopped()):
		if isDamageUp:
			timerBonusShooting.start()
			create_shoot()
		else:
			timerShooting.start()		
			create_shoot()
		
	
func create_shoot():
	var shoot
	if isDamageUp:
		shoot = shootBonus.instance()
		shoot.damage = mcDamage / 1.25
	else: 
		shoot = plShoot.instance()
		shoot.damage = mcDamage
	shoot.global_position = muzzle.global_position
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
	# на телефоне используются другие значения clamp
#	global_position.y = clamp(global_position.y, 50, viewportSize.y - 50)
#	global_position.x = clamp(global_position.x, 50, viewportSize.x - 50) 
	global_position.y = clamp(global_position.y, 50, viewportSize.y - 500)
	global_position.x = clamp(global_position.x, 100, viewportSize.x - 50) 
	 

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
			
			print("Текущий HP: ", mcHP)
			
			HealthCounter.set_points(mcHP)
#			emit_signal("health_changed", mcHP)
			
			hitSound.play()
			
			if mcHP <= 0:
				death()


func death():
	isDead = true
	collision.queue_free()
	mcVSpeed /= 4
	mcSpeed /= 4
	destroyed.play()
	sprite.animation = "Death"
	sprite.playing = true
	#sprite.connect("animation_finished", self, "_on_Death_Animation")
	destroyed.connect("finished", self, "_on_Death_Animation")
	DeathMenu.set_is_over(true)


func _on_Death_Animation():
	Input.parse_input_event(game_over)


func burning(delay:int):
	if isInvicibility:
		return
	for _i in range(delay):
		tickRateDamage.start()
		sprite.modulate = "00ff6a"		
		yield(tickRateDamage, "timeout")
	

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
		crushEffects.emitting = false		
		sprite.animation = "FullHP"
	elif MCCurrentState >= 0.6:
		crushEffects.emitting = true			
		sprite.animation = "SemiHP"
	elif MCCurrentState >= 0.4:
		crushEffects.emitting = true					
		sprite.animation = "LowHP"
		crushEffects.amount = 10		
	else: 
		crushEffects.emitting = true	
		sprite.animation = "VeryLowHP"
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
		shieldBonus()
	elif area.is_in_group("DamageBonus"):
		damageBonus()
	elif area.is_in_group("damageable"):
		timerDuringShieldBonus.stop()
		if timerDuringShieldBonus.is_stopped():
			disabledShieldBonus()
	elif area.is_in_group("addDamage"):
		addPassiveDamageBonus()
	elif area.is_in_group("addShootSpeed"):
		addPassiveShootSpeedBonus()
		
		
func heal():
	if mcHP + (maxHP / 4) < maxHP:
		mcHP += maxHP / 4
	else:
		mcHP = maxHP
#	emit_signal("health_changed", mcHP)
	HealthCounter.set_points(mcHP)	
	changeState()

	
func damageBonus():
	isDamageUp = true
	timerDuringDamageBonus.start(duringDamageBonus)
	timerShooting.stop()
	
	
func disabledDamageBonus():
	isDamageUp = false
	
	
func shieldBonus():
	isInvicibility = true
	timerDuringShieldBonus.start(duringShieldBonus)
	timerShieldRestoring.stop()
	shield.animation = "invincibility"


func disabledShieldBonus():
	isInvicibility = false
	shield.animation = "autoshield"


func addPassiveDamageBonus():
	mcDamage *= 2
	
	
func addPassiveSpeed():
	mcVSpeed += floor(mcVSpeed * 0.1)
	mcSpeed += floor(mcSpeed * 0.1)
	
	
func addPassiveMultiscoreBonus():
	get_tree().current_scene.multiscore += 0.1
	
	
func addPassiveShootSpeedBonus():
	HealthCounter.set_points(mcDamage)
	if shootDelay > 0.1:
		shootDelay -= 0.05 
	timerShooting.set_wait_time(shootDelay)
	

func addPassiveMaxHPBonus():
	maxHP += 10
	mcHP += 10
	HealthCounter.set_points(mcHP)

	
func _on_tickRateDamage_timeout():
	takeDamage(mcHP * 0.2)
	sprite.modulate = "ffffff"


func stat_inizialization() -> void:
	
	HealthCounter = get_tree().current_scene.get_node("GUI/Control/HBoxContainer/VBoxContainer4/HealthCounter")
	
	DamageCounter = get_tree().current_scene.get_node("GUI/DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer6/DamageCounter")
	RPSCounter    = get_tree().current_scene.get_node("GUI/DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer2/RPSCounter")
	SpeedCounter  = get_tree().current_scene.get_node("GUI/DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer2/SpeedCounter")
	
	DamageCounterP = get_tree().current_scene.get_node("GUI/PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer6/DamageCounter")
	RPSCounterP    = get_tree().current_scene.get_node("GUI/PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer2/RPSCounter")
	SpeedCounterP  = get_tree().current_scene.get_node("GUI/PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer2/SpeedCounter")
	
	DeathMenu      = get_tree().current_scene.get_node("GUI/DeathMenu")
	
	HealthCounter.set_points(mcHP)
	
	DamageCounter.set_points(mcDamage)
	RPSCounter.set_points(round(1 / shootDelay))
	SpeedCounter.set_points(mcSpeed)
	
	DamageCounterP.set_points(mcDamage)
	RPSCounterP.set_points(round(1 / shootDelay))
	SpeedCounterP.set_points(mcSpeed)
