extends Enemy


class_name BattleEnemy


export (float) var enemyAttackDelay = 1 


onready var muzzles = $FiringPositions


var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn")
# res://src/actors/Projectiles/BattleEnemyShoot/BattleEnemyShoot.tscn


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
		for muzzle in muzzles.get_children():
			var shoot = plShoot.instance()
			shoot.global_position = muzzle.global_position
			get_tree().current_scene.add_child(shoot)
	
