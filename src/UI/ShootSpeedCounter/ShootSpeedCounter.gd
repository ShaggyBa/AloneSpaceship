extends NinePatchRect

onready var points_label := $Label
	

func set_points(points: float) -> void:
	if points >= 10:
		points_label.text = "MAX"
	else:
		points_label.text = String(points) + 'X'
	
	
func get_points():
	return String(points_label.text)
