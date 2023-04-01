extends Enemy


export (float) var enemyBigAttackDelay = 2.5 
export (float) var enemyAttackDelay = 1 


onready var muzzles = $FiringPositions.get_children()

onready var groupBigGun = [muzzles[0], muzzles[1]]


var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn")
var plShootBig = preload("res://src/actors/Projectiles/BattleEnemyShoot/BattleEnemyShoot.tscn")


var timerBigShooting = Timer.new()
var timerShooting = Timer.new()

var currentGroupGun = true
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

	timerBigShooting.set_one_shot(true)
	timerBigShooting.set_wait_time(enemyBigAttackDelay)
	add_child(timerBigShooting)
	

func shooting():
	if timerBigShooting.is_stopped():
		timerBigShooting.start()	
		for muzzle in groupBigGun:
			var shoot = plShootBig.instance()
			shoot.global_position = muzzle.global_position
			get_tree().current_scene.add_child(shoot)
				
		currentGroupGun = !currentGroupGun
				
	if timerShooting.is_stopped():
		timerShooting.start()
		var shoot = plShoot.instance()				
		if not currentGun:
			shoot.global_position = muzzles[2].global_position
		else:
			shoot.global_position = muzzles[3].global_position			
		get_tree().current_scene.add_child(shoot)
		currentGun = !currentGun
	
