extends Area2D


export (float) var speed = 100.0


var meteoriteHP = 1


signal meteoriteIsHitting

#var isEntered = false

func _physics_process(delta):
	position.x -= speed * delta
		


func takeDamage(damage):
	meteoriteHP -= damage
	if meteoriteHP <= 0:	
		queue_free()
		print("Meteorite is destroyed")


func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(1)


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
		print("Meteorite exited viewport")
		queue_free()
