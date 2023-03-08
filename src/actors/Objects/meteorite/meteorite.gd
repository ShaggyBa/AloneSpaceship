extends Area2D


export (float) var speed = 100.0


var meteoriteHP = 1


signal meteoriteIsHitting


func _process(delta: float):
	global_position.x -= speed * delta


func takeDamage(damage):
	meteoriteHP -= damage
	if meteoriteHP <= 0:
		queue_free()


func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(1)
