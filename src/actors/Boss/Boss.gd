extends Area2D


@export var bossAttackDelay: float = 2.0
@export var verticalSpeed: float = 100.0
@export var horisontalSpeed: float = 75.0
@export var bossHP: int = 50
@export var bossDamage: int = 10


signal boss_defeated


@onready var viewportRect = get_viewport_rect()
@onready var canShoot = true


@onready var aSprite = $Sprite2D
@onready var engine = $Engine
@onready var attackSound = $Attack
@onready var takeDamageSound = $TakeDamage
@onready var muzzle = $muzzle


@onready var _target = get_tree().current_scene.get_node("MC")
@onready var _positionToReady = get_tree().current_scene.get_node("positionToReady").global_position

@onready var plShoot = preload("res://src/actors/Projectiles/BossShoot/BossShoot.tscn")
@onready var viewportEndX = viewportRect.end.x + 210


var directionY = 1
var directionX = -1

var timerRay = Timer.new()
var timerShooting = Timer.new()

var stateChanged = false
var isReady = false
var isDeath = false
var maxHP

func _ready() -> void:
	improve_stats()
	aSprite.play()
	engine.play()
	setTimerShooting()
	

func _physics_process(delta):
	moving(delta)
	
	
func _process(_delta: float) -> void:
	shooting()


func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(bossAttackDelay)
	add_child(timerShooting)



func shooting():
	if timerShooting.is_stopped() and canShoot and isReady:
		timerShooting.start()	
		aSprite.animation = "attack"
		attackSound.play()
		var shoot = plShoot.instantiate()
		
		await get_tree().create_timer(1.0).timeout
		if isDeath:
			return
		shoot.damage = bossDamage
		shoot.global_position = muzzle.global_position
		
		if stateChanged:
			var shoot2 = plShoot.instantiate()
			shoot2.damage = bossDamage
			shoot2.global_position = muzzle.global_position
			
			var doubleShoot = [shoot, shoot2]
			for i in doubleShoot:
				get_tree().current_scene.add_child(i)
				await get_tree().create_timer(0.15).timeout
		else:
			get_tree().current_scene.add_child(shoot)
		

func takeDamage(amount):
	if isDeath:
		return
	bossHP -= amount
	takeDamageSound.play()	
	changeState()
	if bossHP <= 0:
		death()


func moving(delta:float) :
	global_position.x += horisontalSpeed * delta * directionX
	global_position.y += verticalSpeed * delta * directionY
	
	if global_position.y < viewportRect.position.y + 50 \
	or global_position.y > viewportRect.end.y - 50:
		directionY *= -1
		
	if global_position.x < viewportRect.end.x / 2 \
	or global_position.x > viewportEndX:
		directionX *= -1

	if global_position.x <= _positionToReady.x and not isReady:
		viewportEndX -= 290
		isReady = true
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Boss_area_entered(area):
	if area is MC:
		area.takeDamage(bossDamage*5)
		bossHP -= area.mcDamage * 10


func _on_Death_animation_finished():
	bossDefeated()
	queue_free()


func changeState():
	if float(bossHP) / float(maxHP) <= 0.5 and not stateChanged:
		bossAttackDelay = 1		
		timerShooting.set_wait_time(bossAttackDelay)
		aSprite.modulate = "f76969"

		aSprite.speed_scale = 2
		bossDamage *= floor(1.5)
		attackSound.pitch_scale = 2
		verticalSpeed *= 2
		horisontalSpeed *= 2.5

		stateChanged = true
		

func improve_stats():
	bossHP += _target.maxHP * (1.0 / _target.mcShootSpeed) + _target.mcDamage * \
	(1.0 / _target.mcShootSpeed)
	
	bossDamage += randf_range(_target.mcDamage / 2, _target.mcDamage)

	maxHP = bossHP

func death():
	if isDeath:
		return
	isDeath = true
	canShoot = false
	
	engine.queue_free()
	
	$CollisionPolygon2D.queue_free()	
	
	var death_finished := Callable(self, "_on_Death_animation_finished")
	if not aSprite.animation_finished.is_connected(death_finished):
		aSprite.animation_finished.connect(death_finished)
	aSprite.play("Death")
	aSprite.set_frame_and_progress(0, 0.0)
	verticalSpeed *= 0.1
	horisontalSpeed *= 0.1
	$Destroyed.play()
	

func bossDefeated():
	# Код, выполняемый при победе над боссом
	emit_signal("boss_defeated")
