extends Enemy


export (float) var enemyAttackDelay = 1 


var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn") 


onready var muzzle = $Muzzle


var timerShooting = Timer.new()


func _ready() -> void:
	setTimerShooting()


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
		shoot.global_position = $Muzzle.global_position
		get_tree().current_scene.add_child(shoot)
	
