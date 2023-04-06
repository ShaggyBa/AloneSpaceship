extends NinePatchRect

onready var points_label := $Label

func set_points(points: int) -> void:
	if points < 0:
		points = 0
	points_label.text = str(points)

func get_points():
	return int(points_label.text)
