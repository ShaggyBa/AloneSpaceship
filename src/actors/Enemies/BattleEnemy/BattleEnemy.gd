extends enemy

@export (float) var enemyBigAttackDelay = 2.5 
@export (float) var enemyAttackDelay = 1.0 

@export (float) var enemyBigAttackDamage = 5.0


@onready var muzzles = $FiringPositions.get_children()

@onready var groupGun = [muzzles[0], muzzles[1]]

@onready var _positionToReady = get_tree().current_scene.get_node("positionToReady").global_position

@onready var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn")
@onready var plBigShoot = preload("res://src/actors/Projectiles/BattleEnemyShoot/BattleEnemyShoot.tscn")

@onready var viewportEndX = viewportRect.end.x + 210


var timerShooting = Timer.new()

var currentGun = true

var directionX = -1

var directionY = directionX


var isReady = false


var stateChanged = false


func _ready() -> void:
	randomize()
	
	
	enemyAttackDelay = randf_range(enemyAttackDelay - 0.1, enemyAttackDelay + 0.1)
	aSprite.speed_scale = enemyAttackDelay	
	aSprite.playing = true
	enemyBigAttackDamage = round(enemyBigAttackDamage + coef * 2)
	setTimerShooting()


func _process(_delta: float) -> void:
	shooting()


func _physics_process(delta: float) -> void:
	moving(delta)	


func setTimerShooting()->void:
	timerShooting.set_one_shot(true)
	timerShooting.set_wait_time(enemyAttackDelay)
	add_child(timerShooting)


func moving(delta:float)->void:
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


func shooting():
	if timerShooting.is_stopped() and not isDeath and isReady:
		timerShooting.start()
		var shoot = plShoot.instantiate()
		shoot.damage = enemyDamage				
		if not currentGun:
			aSprite.animation = "topGun"				
			shoot.global_position = muzzles[2].global_position
	
			get_tree().current_scene.add_child(shoot)		
			await get_tree().create_timer(0.15).timeout
			
			for muzzle in groupGun:
				var doubleShoot = plBigShoot.instantiate()
				doubleShoot.damage = enemyBigAttackDamage					
				doubleShoot.global_position = muzzle.global_position
				get_tree().current_scene.add_child(doubleShoot)
				
		else:
			aSprite.animation = "bottomGun"				
			shoot.global_position = muzzles[3].global_position			
			get_tree().current_scene.add_child(shoot)
			
		currentGun = !currentGun




func changeState():
	if float(enemyHP) / float(maxHP) <= 0.5 and not stateChanged:
		aSprite.speed_scale = 2
		aSprite.modulate = "f76969"
		enemyAttackDelay = 0.5
		enemyDamage += 2
		verticalSpeed *= 1.1
		horisontalSpeed *= 1.25
		timerShooting.set_wait_time(enemyAttackDelay)
		stateChanged = true
