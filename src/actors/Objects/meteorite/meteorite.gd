extends Area2D


export (float) var speed = 100.0


var meteoriteHP = 1


signal meteoriteIsHitting


func _physics_process(delta):
	global_position.x -= speed * delta
		# эффект затухания
		# set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.1)) - нужно придумать альтернативу
		# выключение коллизии


func takeDamage(damage):
	meteoriteHP -= damage
	if meteoriteHP <= 0:	
		queue_free()


func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(1)
