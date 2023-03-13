extends Area2D

class_name Meteorite

export (float) var speed = 100.0

var meteoriteHP = 1

signal meteoriteIsHitting

func _physics_process(delta):
	global_position.x -= speed * delta
	if meteoriteHP <= 0:	
		# эффект затухания
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.1))

func takeDamage(damage):
	meteoriteHP -= damage

func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(1)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
