extends CPUParticles2D


func _ready():
	amount = rand_range(6, 12)
	emitting = true
		

func _process(_delta):
	if !emitting:
		queue_free()
