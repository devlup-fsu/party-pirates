extends Area2D

@export var score_value := 5
## If variance != 0, player will gain a score_value +- variance on collision.
@export var variance := 0

## If [should_randomize_appearance == true] then $AnimatedSprite2D will randomly choose one of the
## animations listed here.
@export var treasure_types : Array[String] = ["chest", "coin"]
## If true, the treasure's appearance is randomized on ready. Options are listed in treasure_types.
@export var should_randomize_appearance := true

@onready var anim_player : AnimationPlayer = $AnimationPlayer


func _ready():
	if should_randomize_appearance:
		var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
		anim_sprite.animation = treasure_types[randi() % treasure_types.size()]


func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("score_up"):
		body.score_up(score_value + randi_range(-variance, variance))
		
		# Otherwise player may collide with this node multiple times while the animation finishes.
		$CollisionShape2D.disabled = true
		anim_player.play("collected")
		await anim_player.animation_finished
		queue_free()
