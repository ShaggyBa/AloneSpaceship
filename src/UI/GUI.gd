extends CanvasLayer



func _on_UpBtn_pressed():
	Input.action_press("ui_up",1)
	


func _on_DownBtn_pressed():
	Input.action_press("ui_down",1)
	


func _on_UpBtn_resized():
	Input.action_press("ui_up",0)
	Input.action_release("ui_up")


func _on_DownBtn_resized():
	Input.action_press("ui_down",0)
	Input.action_release("ui_down")
