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


# TODO: Uncomment all of this!
func _on_body_entered(player: Player) -> void:
	pass
	#player.score_up(score_value + randi_range(-variance, variance))
	
	# Otherwise player may collide with this node multiple times while the animation finishes.
	#collision_shape.disabled = true
	
	#anim_player.play("collected")
	#await anim_player.animation_finished
	#queue_free()
