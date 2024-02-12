class_name Pickup2D
extends Area2D

signal picked_up(Pickup2D)

@export var pickup: Pickup

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_collected := false
var auto_delete := true


func _ready() -> void:
	assert(pickup != null, "Pickup2D: Pickup resource must be set on the inspector.")
	auto_delete = pickup.auto_delete
	pickup.physical_self = self
	if pickup.appearance != null:
		anim_sprite.sprite_frames = pickup.appearance
	var animations = anim_sprite.sprite_frames.get_animation_names()
	anim_sprite.animation = animations[randi() % animations.size()]


func collect() -> void:
	is_collected = true
	collision_shape.set_deferred("disabled", true)
	anim_player.play("collect")
	picked_up.emit(self)
	if auto_delete: queue_free()


func drop() -> void:
	is_collected = false
	collision_shape.set_deferred("disabled", false)
	anim_player.play("drop")




func _on_player_contacted(body: Player):
	body.accept_pickup(pickup)
