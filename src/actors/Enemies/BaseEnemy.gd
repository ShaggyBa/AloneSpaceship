extends Area2D


class_name Enemy


export (float) var verticalSpeed = 50.0
export (float) var horisontalSpeed = 100.0
export (int) var enemyHP = 1
export (int) var enemyDamage = 1
var kill_points = 25 #очки за убийство противника


var direction = 1

onready var hit = $Audio/Hit
onready var destroyed = $Audio/Destroyed


onready var viewportRect = get_viewport_rect()
onready var isDeath = false
onready var maxHP = enemyHP

signal add_to_score(value) #value: int
var enemy_death = InputEventAction.new()

onready var aSprite = $AnimatedSprite
onready var engine = $Engine
onready var collision = $CollisionPolygon2D


func _ready() -> void:
	aSprite.playing = true
	engine.playing = true
	enemy_death.action = "enemy_death"
	enemy_death.pressed = true
	

func _physics_process(delta):
	moving(delta)


func moving(delta:float)->void:
	global_position.x -= horisontalSpeed * delta
	global_position.y += verticalSpeed * delta * direction
	if global_position.y < viewportRect.position.y + 15 \
	or global_position.y > viewportRect.end.y - 15:
		direction *= -1


func takeDamage(amount):
	enemyHP -= amount
	hit.play()	
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
	isDeath = true
	
	engine.queue_free()
	
	collision.queue_free()
	aSprite.animation = "Death"
	aSprite.connect("animation_finished", self, "_on_Death_animation_finished")
	aSprite.playing = true
	destroyed.play()
	
	horisontalSpeed /= 4
	verticalSpeed /= 4


func _on_Death_animation_finished():
	queue_free()




