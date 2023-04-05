extends NinePatchRect

onready var points_label := $HBoxContainer/Label

func set_points(points: int) -> void:
	if points < 0:
		points = 0
	points_label.text = str(points)
