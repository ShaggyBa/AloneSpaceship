extends Area2D


class_name Enemy


export (float) var verticalSpeed = 50.0
export (float) var horisontalSpeed = 100.0
export (int) var enemyHP = 1
export (int) var enemyDamage = 1
var kill_points = 2500 #очки за убийство противника


var direction = 1

onready var hit = $Audio/Hit
onready var destroyed = $Audio/Destroyed


onready var viewportRect = get_viewport_rect()
onready var isDeath = false
onready var maxHP = enemyHP


onready var aSprite = $AnimatedSprite
onready var engine = $Engine
onready var collision = $CollisionPolygon2D

onready var KillsCounter
onready var KillsCounterP
onready var ScoreCounter

func _ready() -> void:
	aSprite.playing = true
	engine.playing = true
	KillsCounterP = get_tree().current_scene.get_node("GUI/PauseMenu/CenterContainer2/HBoxContainer/VBoxContainer6/KillsCounter")
	KillsCounter  = get_tree().current_scene.get_node("GUI/DeathMenu/CenterContainer2/HBoxContainer/VBoxContainer6/KillsCounter")
	ScoreCounter  = get_tree().current_scene.get_node("GUI/Control/HBoxContainer/VBoxContainer4/ScoreCounter")


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
		KillsCounter.increase_points()
		KillsCounterP.increase_points()
		ScoreCounter.increase_points_on(kill_points)
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




