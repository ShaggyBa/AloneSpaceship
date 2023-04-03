extends Enemy

export (float) var enemyAttackDelay = 1 


onready var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn") 

onready var muzzles = $FiringPositions.get_children()	

var timerShooting = Timer.new()
var currentGun = true

func _ready() -> void:
	setTimerShooting()
	$AnimatedSprite.playing = true

func _process(delta: float) -> void:
	shooting()


func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(enemyAttackDelay)
	add_child(timerShooting)
	


func shooting():
	
	if timerShooting.is_stopped():
		timerShooting.start()		
		var shoot = plShoot.instance()
		if not currentGun:
			shoot.global_position = muzzles[0].global_position
		else:
			shoot.global_position = muzzles[1].global_position			
		get_tree().current_scene.add_child(shoot)
		currentGun = !currentGun

