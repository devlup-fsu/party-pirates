class_name Treasure
extends Area2D

@export var value := 1

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_collected := false


func _ready() -> void:
	var animations = anim_sprite.sprite_frames.get_animation_names()
	anim_sprite.animation = animations[randi() % animations.size()]


func _process(delta: float) -> void:
	if is_collected:
		anim_sprite.scale = anim_sprite.scale.lerp(Vector2(0.75, 0.75), delta)
	else:
		anim_sprite.scale = anim_sprite.scale.lerp(Vector2(1.00, 1.00), delta)


func collect() -> void:
	is_collected = true
	collision_shape.set_deferred("disabled", true)


func drop() -> void:
	is_collected = false
	collision_shape.set_deferred("disabled", false)
