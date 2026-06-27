extends enemy

@export var enemyBigAttackDelay: float = 2.5 
@export var enemyAttackDelay: float = 1.0 

@export var enemyBigAttackDamage: float = 5.0


@onready var muzzles = $FiringPositions.get_children()

@onready var groupGun = [muzzles[0], muzzles[1]]

@onready var plShoot = preload("res://src/actors/Projectiles/EnemyShoot/EnemyShoot.tscn")
@onready var plBigShoot = preload("res://src/actors/Projectiles/BattleEnemyShoot/BattleEnemyShoot.tscn")

@onready var viewportEndX = viewportRect.end.x + 210


var timerShooting = Timer.new()

var currentGun = true

var directionX = -1

var directionY = directionX


var isReady = false


var stateChanged = false
var ready_position := Vector2.ZERO


func _ready() -> void:
	super._ready()
	randomize()
	ready_position = get_ready_position()
	
	
	enemyAttackDelay = randf_range(enemyAttackDelay - 0.1, enemyAttackDelay + 0.1)
	aSprite.speed_scale = enemyAttackDelay	
	aSprite.play()
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

	if global_position.x <= ready_position.x and not isReady:
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
	
			SpawnService.spawn(shoot)
			await get_tree().create_timer(0.15).timeout
			
			for muzzle in groupGun:
				var doubleShoot = plBigShoot.instantiate()
				doubleShoot.damage = enemyBigAttackDamage					
				doubleShoot.global_position = muzzle.global_position
				SpawnService.spawn(doubleShoot)
				
		else:
			aSprite.animation = "bottomGun"				
			shoot.global_position = muzzles[3].global_position			
			SpawnService.spawn(shoot)
			
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


func get_ready_position() -> Vector2:
	var marker := get_tree().get_first_node_in_group("enemy_ready_position") as Node2D
	if marker != null:
		return marker.global_position
	return Vector2(viewportRect.end.x / 2, viewportRect.end.y / 2)
