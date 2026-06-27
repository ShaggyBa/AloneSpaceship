extends Area2D

class_name Meteorite

@export var minSpeed: float = 20.0
@export var maxSpeed: float = 100.0
@export var minRotationRate: float = -20.0
@export var maxRotationRate: float = 20.0

@export var meteoriteHP: int = 1

@export var minScale: float = 0.8
@export var maxScale: float = 2.5

var speed = null
var rotationSpeed = null
var randomScale = null
var is_destroyed := false


@onready var takeHit = $Audio/Hit
@onready var destroyed = $Audio/Destroyed

@onready var collision = $CollisionShape2D
@onready var mSprite = $Sprite2D

var pMeteoriteEffect = preload("res://src/actors/Objects/meteorite/MeteoriteEffect.tscn")


func _ready():
	randomize()
	speed = randf_range(minSpeed, maxSpeed)
	rotationSpeed = randf_range(minRotationRate, maxRotationRate)
	randomScale = randf_range(minScale, maxScale)
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
	if is_destroyed:
		return
	is_destroyed = true
	
	collision.queue_free()
	
	destroyed.play()
	spawnMeteoriteEffect()
	mSprite.queue_free()
	
func spawnMeteoriteEffect():
	var meteoriteEffect = pMeteoriteEffect.instantiate()
	var effect_position: Vector2 = mSprite.to_global(mSprite.get_rect().get_center())
	meteoriteEffect.texture = mSprite.texture
	meteoriteEffect.position = effect_position
	meteoriteEffect.rotation = mSprite.global_rotation
	meteoriteEffect.scale = scale * mSprite.scale
	meteoriteEffect.global_position = effect_position
	get_tree().current_scene.add_child(meteoriteEffect)
	meteoriteEffect.global_position = effect_position
	meteoriteEffect.global_rotation = mSprite.global_rotation
	meteoriteEffect.start_effect()
	print("[Meteorite] Spawned destruction effect at %s node_origin=%s sprite_global=%s scale=%s texture=%s" % [meteoriteEffect.global_position, global_position, mSprite.global_position, meteoriteEffect.scale, meteoriteEffect.texture])
	

func _on_Meteorite_area_entered(area: Area2D) -> void:
	if area is MC:
		area.takeDamage(meteoriteHP)
		death()
	if area.is_in_group("boss"):
		death()

 
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
