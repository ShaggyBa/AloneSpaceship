extends Area2D

class_name Bonus 

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_AroundShield_area_entered(area):
	emit_signal("area_entered")
	queue_free()
