extends Area2D


class_name enemy


@export var verticalSpeed: float = 50.0
@export var horisontalSpeed: float = 100.0
@export var enemyHP: int = 1
@export var enemyDamage: int = 1
var kill_points = 25 #очки за убийство противника


var direction = 1

@onready var hit = $Audio/Hit
@onready var destroyed = $Audio/Destroyed


@onready var viewportRect = get_viewport_rect()
@onready var isDeath = false

@onready var aSprite = $AnimatedSprite2D
@onready var engine = $Engine
@onready var collision = $CollisionPolygon2D


#signal add_to_score(value) #value: int
var enemy_death = InputEventAction.new()
var maxHP

var coef = 1.0


func _ready() -> void:
	aSprite.play()
	aSprite.connect("animation_finished", Callable(self, "_on_Death_animation_finished"))	
	engine.play()
	enemy_death.action = "enemy_death"
	enemy_death.pressed = true
	
	enemyHP = floor(enemyHP * coef)
	enemyDamage = round(enemyDamage + coef)
	maxHP = enemyHP

func _physics_process(delta):
	moving(delta)


func moving(delta:float)->void:
	global_position.x -= horisontalSpeed * delta
	global_position.y += verticalSpeed * delta * direction
	if global_position.y < viewportRect.position.y + 15 \
	or global_position.y > viewportRect.end.y - 15:
		direction *= -1


func takeDamage(amount):
	if isDeath:
		return
	enemyHP -= amount
	hit.play()	
	if coef > 5:
		changeState()
	
	if enemyHP <= 0:
		Input.parse_input_event(enemy_death)
		death()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BaseEnemy_area_entered(area):
	if area is MC:
		area.takeDamage(enemyDamage*5)
		death()
		
		
func death():
	if isDeath:
		return
	isDeath = true
	
	engine.queue_free()
	
	collision.queue_free()
	var death_finished := Callable(self, "_on_Death_animation_finished")
	if not aSprite.animation_finished.is_connected(death_finished):
		aSprite.animation_finished.connect(death_finished)
	aSprite.play("Death")
	aSprite.set_frame_and_progress(0, 0.0)
	destroyed.play()
	
	horisontalSpeed *= 0.3
	verticalSpeed *= 0.3


func _on_Death_animation_finished():
	if isDeath:
		queue_free()


func changeState():
	pass

