extends NinePatchRect

onready var points_label := $Label
onready var static_points = 0
	
func set_points(points: int) -> void:
	if points < 0:
		points = 0
	points_label.text = str(points)
	static_points = points

func increase_points() -> void:
	static_points += 1
	points_label.text = str(static_points)
	
func increase_points_on(value) -> void:
	static_points += value
	points_label.text = str(static_points)	

func get_points():
	return static_points
