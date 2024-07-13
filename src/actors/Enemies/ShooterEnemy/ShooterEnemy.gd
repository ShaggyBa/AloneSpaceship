extends enemy

@export (float) var enemyAttackDelay = 1.0


@onready var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn") 

@onready var muzzles = $FiringPositions.get_children()	

@onready var shot = $Audio/shoot


var timerShooting = Timer.new()
var currentGun = true

func _ready() -> void:
	setTimerShooting()
	aSprite.playing = true

func _process(_delta: float) -> void:
	shooting()


func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(enemyAttackDelay)
	add_child(timerShooting)
 

func shooting():
	if timerShooting.is_stopped() and not isDeath:
		timerShooting.start()		
		var shoot = plShoot.instantiate()
		shoot.damage = enemyDamage
		if not currentGun:
			aSprite.animation = "topGunShoot"
			shoot.global_position = muzzles[0].global_position
		else:
			aSprite.animation = "bottomGunShoot"			
			shoot.global_position = muzzles[1].global_position		
		get_tree().current_scene.add_child(shoot)
		currentGun = !currentGun

