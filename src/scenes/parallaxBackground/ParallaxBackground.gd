extends ParallaxBackground

@export onready var speedScroll = 200

var direction = Vector2(1, 0)

func _ready():
	$CPUParticles2D.emitting = true
	
func _process(delta):
	scroll_offset -= direction * speedScroll * delta
	

