extends Area2D


@export (float) var rayDuracity = 2.0
@export (float) var speed = 750.0


@onready var timerRayDuracity = $TimerRayDuracity
@onready var raySprite = $Ray


@onready var _target = get_tree().current_scene.get_node("MC").global_position
var targetPos = Vector2.ZERO


var damage


func _ready() -> void:
	timerRayDuracity.start(rayDuracity)
	raySprite.playing = true
	
	var angle = get_angle_to(_target)
	targetPos = Vector2(cos(angle), sin(angle))
	
	rotation = _target.angle_to_point(position)


func _physics_process(delta: float) -> void:
	global_position += targetPos * speed * delta
	

func _on_TimerRayDuracity_timeout() -> void:
	queue_free()


func _on_BossShoot_area_entered(area: Area2D) -> void:
	if area.is_in_group("damageable") or area is MC:
		area.takeDamage(damage)
		
		if area is MC:
			area.burning(int(rayDuracity))
		
