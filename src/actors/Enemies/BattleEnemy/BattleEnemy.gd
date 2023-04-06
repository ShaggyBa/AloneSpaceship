extends Enemy


export (float) var enemyBigAttackDelay = 2.5 
export (float) var enemyAttackDelay = 1.0 


onready var muzzles = $FiringPositions.get_children()
onready var aSprite = $AnimatedSprite

onready var groupGun = [muzzles[0], muzzles[1]]



onready var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn")
onready var plBigShoot = preload("res://src/actors/Projectiles/BattleEnemyShoot/BattleEnemyShoot.tscn")

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
		var shoot = plShoot.instance()
		shoot.damage = enemyDamage				
		if not currentGun:
			aSprite.animation = "topGun"				
			shoot.global_position = muzzles[2].global_position
	
			get_tree().current_scene.add_child(shoot)		
			yield(get_tree().create_timer(0.15), "timeout")
			
			for muzzle in groupGun:
				var doubleShoot = plBigShoot.instance()
				doubleShoot.damage = enemyDamage					
				doubleShoot.global_position = muzzle.global_position
				get_tree().current_scene.add_child(doubleShoot)
				
		else:
			aSprite.animation = "bottomGun"				
			shoot.global_position = muzzles[3].global_position			
			get_tree().current_scene.add_child(shoot)
			
		currentGun = !currentGun


func changeState():
	if float(enemyHP) / float(maxHP) == 0.2:
		aSprite.speed_scale = 2
		aSprite.modulate = "f76969"
		enemyAttackDelay = 0.5
		enemyDamage += 2
		verticalSpeed += 100
		timerShooting.set_wait_time(enemyAttackDelay)
