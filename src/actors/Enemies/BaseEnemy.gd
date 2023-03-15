extends Area2D


class_name Enemy


export (float) var verticalSpeed = 100.0
export (float) var horisontalSpeed = 200.0
export (int) var enemyHP = 5
export (int) var enemyDamage = 1


func _physics_process(delta):
	position.x -= horisontalSpeed * delta
	if enemyHP <= 0:
		queue_free()


func takeDamage(amount):
	enemyHP -= amount
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BaseEnemy_area_entered(area):
	if area is MC:
		area.takeDamage(enemyDamage*10)
		enemyHP = 0
