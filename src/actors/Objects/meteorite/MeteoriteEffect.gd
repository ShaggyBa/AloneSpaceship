extends CPUParticles2D

var started := false


func _ready():
	emitting = false
		

func _process(_delta):
	if started and !emitting:
		queue_free()


func start_effect() -> void:
	amount = randi_range(6, 12)
	started = true
	restart()
	emitting = true
