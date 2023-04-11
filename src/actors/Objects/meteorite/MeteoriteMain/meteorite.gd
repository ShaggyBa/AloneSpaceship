extends Area2D

class_name Meteorite

export (float) var minSpeed = 20.0
export (float) var maxSpeed = 100.0
export (float) var minRotationRate = -20.0
export (float) var maxRotationRate = 20.0

export (int) var meteoriteHP = 1

export (float) var minScale = 0.8
export (float) var maxScale = 2.5

var speed = null
var rotationSpeed = null
var randomScale = null


onready var takeHit = $Audio/Hit
onready var destroyed = $Audio/Destroyed

onready var collision = $CollisionShape2D
onready var mSprite = $Sprite

var pMeteoriteEffect = preload("res://src/actors/Objects/meteorite/MeteoriteEffect.tscn")


func _ready():
	randomize()
	speed = rand_range(minSpeed, maxSpeed)
	rotationSpeed = rand_range(minRotationRate, maxRotationRate)
	randomScale = rand_range(minScale, maxScale)
	meteoriteHP += int(randomScale)
	scale = Vector2(randomScale,  randomScale)
	
func _process(delta):
	global_position.x -= speed * delta
	rotation_degrees += rotationSpeed * delta 
		
		
func takeDamage(damage):
	meteoriteHP -= damage
	takeHit.play()
	if meteoriteHP <= 0:	
		death()

func death():
	
	collision.queue_free()
	mSprite.queue_free()
	
	destroyed.play()
	spawnMeteoriteEffect()
	
func spawnMeteoriteEffect():
	var meteoriteEffect = pMeteoriteEffect.instance()
	meteoriteEffect.texture = mSprite.texture
	meteoriteEffect.position = Vector2(position.x, position.y + 50)
	meteoriteEffect.scale = scale
	get_parent().add_child(meteoriteEffect)
	

func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(meteoriteHP)
		death()
	if area.is_in_group("boss"):
		death()

 
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
