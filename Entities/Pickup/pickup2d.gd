class_name Pickup2D
extends Area2D

signal picked_up(Pickup2D)

@export var pickup: Pickup

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_collected := false

func _ready() -> void:
	assert(pickup != null, "Pickup2D: Pickup resource must be set on the inspector.")
	
	var animations = anim_sprite.sprite_frames.get_animation_names()
	anim_sprite.animation = animations[randi() % animations.size()]


func collect(target: Player) -> void:
	pickup.set_target(target)
	emit_signal("picked_up", self)


func drop(target: Player) -> void:
	pass
