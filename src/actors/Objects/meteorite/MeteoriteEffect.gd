extends CPUParticles2D


func _ready():
	amount = randf_range(6.0, 12.0)
	emitting = true
		

func _process(_delta):
	if !emitting:
		queue_free()
