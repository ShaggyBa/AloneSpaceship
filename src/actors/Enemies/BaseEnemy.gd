extends Area2D


class_name Enemy


export (float) var verticalSpeed = 50.0
export (float) var horisontalSpeed = 100.0
export (int) var enemyHP = 1
export (int) var enemyDamage = 1



var direction = 1

onready var hit = $Audio/Hit
onready var destroyed = $Audio/Destroyed


#onready var playerInst = get_tree().current_scene.get_node("MC")

onready var viewportRect = get_viewport_rect()
onready var isDeath = false
onready var maxHP = enemyHP


onready var aSprite = $AnimatedSprite
onready var engine = $Engine
onready var deathAnimation = $Death
onready var collision = $CollisionPolygon2D


func _ready() -> void:
	aSprite.playing = true
	engine.playing = true
	

func _physics_process(delta):
	global_position.x -= horisontalSpeed * delta
	global_position.y += verticalSpeed * delta * direction
	if global_position.y < viewportRect.position.y + 15 \
	or global_position.y > viewportRect.end.y - 15:
		direction *= -1


func takeDamage(amount):
	enemyHP -= amount
	hit.play()	
	changeState()
	if enemyHP <= 0:
		death()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BaseEnemy_area_entered(area):
	if area is MC:
		area.takeDamage(enemyDamage*5)
		death()
		
		
func death():
	isDeath = true
	
	aSprite.visible = false
	aSprite.playing = false
	
	engine.visible = false
	engine.playing = false
	
	collision.queue_free()
	deathAnimation.playing = true
	destroyed.play()
	
	horisontalSpeed /= 2
	verticalSpeed /= 2


func _on_Death_animation_finished():
	queue_free()


func changeState():
	pass



