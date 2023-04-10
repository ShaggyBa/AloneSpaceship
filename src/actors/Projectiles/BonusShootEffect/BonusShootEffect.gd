extends Sprite


export (float) var effectDelay = 0.05


var timer = Timer.new()


func _ready():
	setTimer()
	timer.start()	
	
	
func _process(_delta):
	if timer.is_stopped():
		queue_free()
		
	
func setTimer():
	timer.set_one_shot(true)
	timer.set_wait_time(effectDelay)
	add_child(timer)
	

