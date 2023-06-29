extends NinePatchRect

onready var points_label := $Label
	

func set_points(points: String) -> void:
	points_label.text = points
	
	
func get_points():
	return String(points_label.text)
