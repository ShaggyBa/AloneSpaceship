extends Area2D


export (float) var bossAttackDelay = 2.0
export (float) var verticalSpeed = 35.0
export (float) var horisontalSpeed = 10.0
export (int) var bossHP = 50
export (int) var bossDamage = 10


onready var viewportRect = get_viewport_rect()
onready var endPositionX = viewportRect.end.x + 200

onready var canShoot = true


onready var aSprite = $Sprite
onready var engine = $Engine
onready var attackSound = $Attack
onready var takeDamageSound = $TakeDamage
onready var muzzle = $muzzle


onready var _target = get_tree().current_scene.get_node("MC")
onready var _checkoutPosition = get_tree().current_scene.get_node("ReadyPoint").global_position

onready var plShoot = preload("res://src/actors/Projectiles/BossShoot/BossShoot.tscn")


var directionY = 1
var directionX = -1

var timerRay = Timer.new()
var timerShooting = Timer.new()

var stateChanged = false
var readyPosition = false

var maxHP


func _ready() -> void:
	aSprite.playing = true
	engine.playing = true
	
	bossHP += _target.maxHP * _target.mcDamage
	bossDamage += _target.mcDamage * 5
	
	maxHP = bossHP
	
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
	if timerShooting.is_stopped() and canShoot:
		timerShooting.start()	
		aSprite.animation = "attack"
		attackSound.playing = true
	
		
		var shoot = plShoot.instance()
		
		yield(get_tree().create_timer(1.0), "timeout")
		shoot.damage = bossDamage
		shoot.global_position = muzzle.global_position
		
		if stateChanged:
			var shoot2 = plShoot.instance()
			shoot2.damage = bossDamage
			shoot2.global_position = muzzle.global_position
			
			var doubleShoot = [shoot, shoot2]
			for i in doubleShoot:
				get_tree().current_scene.add_child(i)
				yield(get_tree().create_timer(0.15), "timeout")
		else:
			get_tree().current_scene.add_child(shoot)
		

func takeDamage(amount):
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
	or global_position.x > endPositionX:
		directionX *= -1

	if global_position.x <= _checkoutPosition.x and not readyPosition:
		endPositionX -= 300
		readyPosition = true
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Boss_area_entered(area):
	if area is MC:
		area.takeDamage(bossDamage*5)
		bossHP -= area.mcDamage * 2
		
		
func death():
	canShoot = false
	
	engine.queue_free()
	
	$CollisionPolygon2D.queue_free()	
	
	aSprite.animation = "Death"
	aSprite.connect("animation_finished", self, "_on_Death_animation_finished")
	aSprite.playing = true
	verticalSpeed *= 0.1
	horisontalSpeed *= 0.1
	$Destroyed.play()


func _on_Death_animation_finished():
	queue_free()


func changeState():
	if float(bossHP) / float(maxHP) <= 0.4 and not stateChanged:
		bossAttackDelay = 1		
		timerShooting.set_wait_time(bossAttackDelay)
		aSprite.modulate = "f76969"

		aSprite.speed_scale = 2
		bossDamage *= floor(1.5)
		attackSound.pitch_scale = 2
		verticalSpeed *= 4
		horisontalSpeed *= 5

		stateChanged = true
		

