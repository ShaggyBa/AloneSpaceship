extends CanvasItem

@onready var points_label := $Counter
	

func set_points(points: int) -> void:
	points_label.text = str(points)
	
	
func get_points():
	return str(points_label.text)
