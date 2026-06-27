extends Area2D
class_name MC

signal health_changed(current_hp: int, max_hp: int)
signal stats_changed(stats: Dictionary)
signal bonus_applied(bonus_type: StringName, source: Node)


@export var mcSpeed: float = 200.0 # cкорость полета корабля
@export var mcVSpeed: float = 300.0 # cкорость вертикального движения корабля

@export var mcHP: int = 5
@export var mcShootSpeed: float = 0.5
@export var mcDamage: int = 1

@export var delayShieldRestoring: float = 0.3

@export var duringShieldBonus: float = 2.0
@export var duringDamageBonus: float = 5.0

@export var coef_hp_bonus: float = 10.0
@export var coef_dmg_bonus: int = 2
@export var coef_shoot_delay_bonus: float = 0.05

var plShoot = preload("res://src/actors/Projectiles/MCShoot/MCShoot.tscn")
var shootBonus = preload("res://src/actors/Projectiles/BonusShoot/ShootBonus.tscn")

var pFullHP = preload("res://src/Assets/Sprites/MainShip/model/States/FullHP.png")
var pSemiHP = preload("res://src/Assets/Sprites/MainShip/model/States/SemiHP.png")
var pLowHP = preload("res://src/Assets/Sprites/MainShip/model/States/LowHP.png")
var pVeryLowHP = preload("res://src/Assets/Sprites/MainShip/model/States/VeryLowHP.png")


@onready var muzzle = $Muzzle
@onready var shield = $Shield
@onready var sprite = $MCSprite
@onready var engineSprite = $EngineSprite
@onready var crushEffects = $CrushEffects
@onready var collision = $CollisionShape2D

@onready var hitSound = $Audio/Hit
@onready var shotSound = $Audio/ShotSound
@onready var shieldHitSound = $Audio/ShieldHit
@onready var gameOverSound = $Audio/ShieldHit
@onready var destroyed = $Audio/Destroyed
@onready var ricochet = $Audio/Ricochet
@onready var activeBonusSound = $Audio/ActiveBonus
@onready var passiveBonusSound = $Audio/PassiveBonus

@onready var passiveBonusSpawner = get_parent().get_node("PassiveBonusSpawner")

@onready var maxHP = mcHP
@onready var startMCSpeed = (mcSpeed + mcVSpeed) / 2
@onready var start_shoot_delay = mcShootSpeed

var inputVector = Vector2.ZERO # вектор скорости
var viewportSize : Vector2


var timerShooting = Timer.new()
var timerBonusShooting = Timer.new()
var timerShieldRestoring = Timer.new()
var timerDuringShieldBonus = Timer.new()
var timerDuringDamageBonus = Timer.new()


var tickRateDamage = Timer.new()

var shootScale = Vector2(1.0, 1.0)

var game_over = InputEventAction.new()


var count_of_dmg_bonus = 0
var count_of_shoot_delay_bonus = 0


var isInvicibility = false
var isDamageUp = false
var isDead = false


func _ready() -> void:
	Main.MC = $"."
	
	viewportSize = get_viewport().size # Получение размеров viewport-а

	setTimerShooting()
	setTimerBonusShooting()
	setTimerInvincibility()
	setTimerShieldBonus()
	setTimerDamageBonus()
	
	setTickRateDamage()
	
	game_over.action = "over"
	game_over.pressed = true
	emit_runtime_state()
		
	
	
func _process(_delta: float) -> void:
	shooting()
	shieldEffect()
	
	
func _physics_process(delta) -> void:
	spaceshipMove(delta)
	
	
func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(mcShootSpeed)
	add_child(timerShooting)
	
	
func setTimerBonusShooting()->void:
	timerBonusShooting.set_one_shot(true)
	timerBonusShooting.set_wait_time(mcShootSpeed)
	add_child(timerBonusShooting)
	
	
func setTimerInvincibility()->void:
	timerShieldRestoring.set_one_shot(true)
	timerShieldRestoring.set_wait_time(delayShieldRestoring)
	add_child(timerShieldRestoring)
	
	
func setTimerShieldBonus()->void:
	timerDuringShieldBonus.set_one_shot(true)
	add_child(timerDuringShieldBonus)
	timerDuringShieldBonus.connect("timeout", Callable(self, "disabledShieldBonus"))
	
	
func setTimerDamageBonus()->void:
	timerDuringDamageBonus.set_one_shot(true)
	add_child(timerDuringDamageBonus)
	timerDuringDamageBonus.connect("timeout", Callable(self, "disabledDamageBonus"))


func setTickRateDamage()->void:
	tickRateDamage.set_one_shot(true)
	tickRateDamage.set_wait_time(1.0)
	tickRateDamage.connect("timeout", Callable(self, "_on_tickRateDamage_timeout"))
	add_child(tickRateDamage)
	

func shooting():
	if isDead:
		return
	
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
		shoot = shootBonus.instantiate()
		shoot.damage = mcDamage / 1.5
	else: 
		shoot = plShoot.instantiate()
		shoot.damage = mcDamage
		shoot.scale = shootScale
	SpawnService.spawn_at(shoot, muzzle.global_position)
	shotSound.play()


func spaceshipMove(delta):
	if isDead:
		return
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	changeStateEngine(inputVector)
	changePosition(inputVector, delta)
	

func changePosition(vector:Vector2, delta:float):
	global_position.x += vector.x * mcSpeed * delta
	global_position.y += vector.y * mcVSpeed * delta 
	global_position.y = clamp(global_position.y, 50, viewportSize.y - 50)
	global_position.x = clamp(global_position.x, 100, viewportSize.x - 50) 
	 

func takeDamage(damage):
	if isInvicibility:
		ricochet.play()
	elif isDead:
		return
	else:	
		if timerShieldRestoring.is_stopped():
			shieldHitSound.play()
			await get_tree().create_timer(0.15).timeout
			timerShieldRestoring.start()
		else:
			if mcHP - damage < 0:
				mcHP = 0
			else:
				mcHP -= damage
				
			changeState()
			emit_runtime_state()
			
			
			hitSound.play()
			
			if mcHP <= 0 and not isDead:
				death()


func burning(delay:int):
	if isInvicibility or isDead:
		return

	sprite.modulate = "00ff6a"				
	for _i in range(delay):
		tickRateDamage.start()
		await tickRateDamage.timeout
	sprite.modulate = "ffffff"				
	

func shieldEffect():
	if isDead:
		return
	if timerShieldRestoring.is_stopped():
		shield.visible = true
		shield.play()
	else:
		shield.visible = false
		shield.stop()
func changeState():
	var MCCurrentState = float(mcHP) / float(maxHP)
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
		engineSprite.play("idle")
	else:
		engineSprite.set_animation("powering")
	engineSprite.play()


func play_bonus_sound(player: AudioStreamPlayer) -> void:
	if player.stream == null:
		return
	player.stop()
	player.play()


func apply_bonus(area: Area2D) -> bool:
	if area.has_meta("bonus_applied"):
		return false

	if area.is_in_group("ActiveBonus"):
		area.set_meta("bonus_applied", true)
		play_bonus_sound(activeBonusSound)
		if area.is_in_group("Heal"):
			heal()
			emit_bonus_event(&"heal", area)
		elif area.is_in_group("ShieldBonus"):
			shieldBonus()
			emit_bonus_event(&"shield", area)
		elif area.is_in_group("DamageBonus"):
			damageBonus()
			emit_bonus_event(&"damage", area)
		return true

	if area.is_in_group("PassiveBonus"):
		area.set_meta("bonus_applied", true)
		play_bonus_sound(passiveBonusSound)
		if area.is_in_group("addDamage"):
			addPassiveDamageBonus()
			emit_bonus_event(&"passive_damage", area)
		elif area.is_in_group("addShootSpeed"):
			addPassiveShootSpeedBonus()
			emit_bonus_event(&"passive_shoot_speed", area)
		elif area.is_in_group("addMaxHP"):
			addPassiveMaxHPBonus()
			emit_bonus_event(&"passive_max_hp", area)
		elif area.is_in_group("addMultiscore"):
			addPassiveMultiscoreBonus()
			emit_bonus_event(&"passive_multiscore", area)
		elif area.is_in_group("addSpeed"):
			addPassiveSpeed()
			emit_bonus_event(&"passive_speed", area)
		return true

	return false


func _on_MC_area_entered(area):
	if apply_bonus(area):
		return

	if area.is_in_group("damageable"):
		timerDuringShieldBonus.stop()
		if timerDuringShieldBonus.is_stopped():
			disabledShieldBonus()
		
			
func heal():
	if mcHP + (maxHP / 4) < maxHP:
		mcHP += maxHP / 2
	else:
		mcHP = maxHP
	changeState()
	emit_runtime_state()
	
		

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
	count_of_dmg_bonus += 1	
	mcDamage += 2
	if shootScale < Vector2(2.5, 2.5):
		shootScale += Vector2(0.25 / count_of_dmg_bonus, 0.25 / count_of_dmg_bonus)
	emit_runtime_state()
	
	
func addPassiveSpeed():
	if mcVSpeed < 900:
		mcVSpeed += floor(mcVSpeed * 0.05)
	if mcSpeed < 900:
		mcSpeed += floor(mcSpeed * 0.05)
		
	if delayShieldRestoring > 1:
		delayShieldRestoring -= 0.1
		timerShieldRestoring.set_wait_time(delayShieldRestoring) 
	emit_runtime_state()
	
	
func addPassiveMultiscoreBonus():
	var current_scene = get_tree().current_scene
	if current_scene != null and current_scene.has_method("add_multiscore"):
		current_scene.add_multiscore(0.25)
	elif current_scene != null and current_scene.get("multiscore") != null:
		current_scene.set("multiscore", float(current_scene.get("multiscore")) + 0.25)
	
	if passiveBonusSpawner.nextSpawnTime > 3:
		passiveBonusSpawner.nextSpawnTime -= 0.1
	
	
func addPassiveShootSpeedBonus():
	if mcShootSpeed > 0.05:
		
		count_of_shoot_delay_bonus += 1		
		
		mcShootSpeed -= coef_shoot_delay_bonus / (sqrt(count_of_shoot_delay_bonus) + coef_shoot_delay_bonus)
		
		timerShooting.set_wait_time(mcShootSpeed)
		emit_runtime_state()
	

func addPassiveMaxHPBonus():
	var coef = 10 + maxHP * 0.1
	maxHP += round(coef)
	mcHP += round(coef)
	emit_runtime_state()


func death():
	isDead = true
	
	get_parent().music.stop()
	
	collision.queue_free()
	destroyed.play()
	shield.queue_free()
	sprite.animation = "Death"
	sprite.modulate = "ffffff" 
	sprite.play()
	sprite.connect("animation_finished", Callable(self, "_on_Destroyed"))


func _on_Destroyed():
	Input.parse_input_event(game_over)


func _on_tickRateDamage_timeout():
	takeDamage(mcHP * 0.2)
	sprite.modulate = "ffffff"


func get_stats_snapshot() -> Dictionary:
	return {
		"hp": mcHP,
		"max_hp": maxHP,
		"speed": (mcSpeed + mcVSpeed) / 2,
		"shoot_delay": mcShootSpeed,
		"damage": mcDamage,
		"is_invincible": isInvicibility,
		"is_damage_up": isDamageUp
	}


func emit_runtime_state() -> void:
	health_changed.emit(mcHP, maxHP)
	stats_changed.emit(get_stats_snapshot())
	GameEvents.emit_health_changed(mcHP, maxHP)
	GameEvents.emit_ship_stats_changed(get_stats_snapshot())


func emit_bonus_event(bonus_type: StringName, source: Node) -> void:
	bonus_applied.emit(bonus_type, source)
	GameEvents.emit_bonus_applied(bonus_type, source)
	emit_runtime_state()
