extends Area2D

class_name ActiveBonus

@export (float) var speed = 500.0

@onready var sprite = $AnimatedSprite2D
@onready var border = $Border

func _ready():
	sprite.playing = true
	border.playing = true

func _physics_process(delta):
	global_position.x -= speed * delta

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _on_Bonus_area_entered(_area):
	queue_free()
