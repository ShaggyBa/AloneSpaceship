extends CanvasItem

onready var points_label := $Counter
	

func set_points(points: String) -> void:
	points_label.text = points
	
	
func get_points():
	return String(points_label.text)
