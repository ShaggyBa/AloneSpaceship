extends Area2D


class_name Enemy


export (float) var verticalSpeed = 100.0
export (float) var horisontalSpeed = 200.0
export (int) var enemyHP = 5
export (int) var enemyDamage = 1


var direction = 1

onready var 	 viewportRect = get_viewport_rect()


func _physics_process(delta):
	global_position.x += horisontalSpeed * delta
	global_position.y += verticalSpeed * delta * direction
	if global_position.y < viewportRect.position.y \
	or global_position.y > viewportRect.end.y:
		direction *= -1
		
	if enemyHP <= 0:
		queue_free()


func takeDamage(amount):
	enemyHP -= amount
	$Destroyed.play()
	$Hit.play()
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BaseEnemy_area_entered(area):
	if area is MC:
		area.takeDamage(enemyDamage*10)
		enemyHP = 0
