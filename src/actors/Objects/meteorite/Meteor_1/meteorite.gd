extends Area2D

class_name Meteorite

export (float) var minSpeed = 20.0
export (float) var maxSpeed = 100.0
export (float) var minRotationRate = -20
export (float) var maxRotationRate = 20

export (int) var meteoriteHP = 1

export (float) var minScale = 0.8
export (float) var maxScale = 2.5

var speed = null
var rotationSpeed = null
var randomScale = null


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
	
	if meteoriteHP <= 0:	
		spawnMeteoriteEffect()
		queue_free()
	
	
func takeDamage(damage):
	meteoriteHP -= damage


func spawnMeteoriteEffect():
	var meteoriteEffect = pMeteoriteEffect.instance()
	meteoriteEffect.texture = $Sprite.texture
	meteoriteEffect.position = Vector2(position.x, position.y + 50)
	meteoriteEffect.scale = scale
	get_parent().add_child(meteoriteEffect)


func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(meteoriteHP)
		meteoriteHP = 0

 
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
