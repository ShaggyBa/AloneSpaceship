extends Area2D


export (float) var bossAttackDelay = 2.0
export (float) var verticalSpeed = 35.0
export (float) var horisontalSpeed = 10.0
export (int) var bossHP = 50
export (int) var bossDamage = 10


onready var viewportRect = get_viewport_rect()
onready var isDeath = false
onready var maxHP = bossHP


onready var sprite = $Sprite
onready var engine = $Engine
onready var attackSound = $Attack
onready var takeDamageSound = $TakeDamage
onready var muzzle = $muzzle


onready var _target = get_tree().current_scene.get_node("MC").global_position

onready var plShoot = preload("res://src/actors/Projectiles/BossShoot/BossShoot.tscn")


var direction = 1


var timerRay = Timer.new()
var timerShooting = Timer.new()


func _ready() -> void:
	sprite.playing = true
	engine.playing = true
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
	if timerShooting.is_stopped() and not isDeath:
		timerShooting.start()	
		sprite.animation = "attack"
		attackSound.playing = true
	
		
		var shoot = plShoot.instance()
		
		yield(get_tree().create_timer(1.0), "timeout")
		shoot.damage = bossDamage
		shoot.global_position = muzzle.global_position
#		shoot.rotation_degrees = _target.angle_to_point(muzzle.position)
		
		get_tree().current_scene.add_child(shoot)
		

func takeDamage(amount):
	bossHP -= amount
	takeDamageSound.play()	
	changeState()
	if bossHP <= 0:
		death()


func moving(delta:float) :
	global_position.x -= horisontalSpeed * delta
	global_position.y += verticalSpeed * delta * direction
	
	if global_position.y < viewportRect.position.y + 50 \
	or global_position.y > viewportRect.end.y - 50:
		direction *= -1


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Boss_area_entered(area):
	if area is MC:
		area.takeDamage(bossDamage*5)
		bossHP -= area.mcDamage * 2
		
		
func death():
	isDeath = true
	
	sprite.visible = false
	sprite.playing = false
	
	engine.visible = false
	engine.playing = false
	
	$CollisionPolygon2D.queue_free()
	$Destroyed.play()


func _on_Destroyed_finished():
	queue_free()


func changeState():
	pass
