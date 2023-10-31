extends Area2D

@export var score_value := 5
## Player will gain a score_value +- variance on collision.
@export var variance := 0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var animations = anim_sprite.sprite_frames.get_animation_names()
	anim_sprite.animation = animations[randi() % animations.size()]


func _on_body_entered(player: Player) -> void:
	player.score_up(score_value + randi_range(-variance, variance))
	
	# Otherwise player may collide with this node multiple times while the animation finishes.
	collision_shape.disabled = true
	
	anim_player.play("collected")
	await anim_player.animation_finished
	queue_free()
