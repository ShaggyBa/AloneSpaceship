extends Control


func _ready():
	pass # Replace with function body.


func _on_StartBtn_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/World.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_OptionsBtn_pressed() -> void:
	get_tree().change_scene_to_file("res://src/UI/Options2.tscn")
