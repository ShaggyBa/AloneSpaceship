extends CanvasItem

@onready var points_label := $Counter
	

func set_points(points: float) -> void:
	points_label.text = str(points) + 'X'
	
	
func get_points():
	return str(points_label.text)
