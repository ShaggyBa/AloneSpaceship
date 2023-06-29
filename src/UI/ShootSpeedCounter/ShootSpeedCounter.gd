extends NinePatchRect

onready var points_label := $Label
	

func set_points(points: float) -> void:
	points_label.text = String(points)
	
	
func get_points():
	return String(points_label.text)
