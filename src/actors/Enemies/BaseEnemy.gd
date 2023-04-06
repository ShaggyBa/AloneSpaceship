extends Area2D


class_name Enemy


export (float) var verticalSpeed = 50.0
export (float) var horisontalSpeed = 100.0
export (int) var enemyHP = 5
export (int) var enemyDamage = 1
var kill_points = 25 #очки за убийство противника

var direction = 1

onready var viewportRect = get_viewport_rect()
onready var isDeath = false
onready var maxHP = enemyHP

signal add_to_score(value) #value: int
var enemy_death = InputEventAction.new()


func _ready():
	enemy_death.action = "enemy_death"
	enemy_death.pressed = true

func _physics_process(delta):
	global_position.x -= horisontalSpeed * delta
	global_position.y += verticalSpeed * delta * direction
	if global_position.y < viewportRect.position.y + 15 \
	or global_position.y > viewportRect.end.y - 15:
		direction *= -1


func takeDamage(amount):
	enemyHP -= amount
	$Hit.play()	
	changeState()
	if enemyHP <= 0:
		#emit_signal("add_to_score",kill_points)
		Input.parse_input_event(enemy_death)
		death()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BaseEnemy_area_entered(area):
	if area is MC:
		area.takeDamage(enemyDamage*5)
		queue_free()
		
		
func death():
	isDeath = true
	$AnimatedSprite.visible = false
	$CollisionPolygon2D.queue_free()
	$Destroyed.play()


func _on_Destroyed_finished():
	queue_free()


func changeState():
	pass
