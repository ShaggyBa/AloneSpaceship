extends CanvasItem

onready var points_label := $Counter
	

func set_points(points: int) -> void:
	points_label.text = String(points)
	
	
func get_points():
	return String(points_label.text)
