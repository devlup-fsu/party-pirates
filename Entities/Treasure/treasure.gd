extends Area2D

@export var score_value := 5
## If variance is not 0, player will gain a score_value +- variance.
@export var variance := 0

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("score_up"):
		body.score_up(score_value + randi_range(-variance, variance))
		anim_player.play("collected")
		# Otherwise player may collide multiple times while the animation finishes.
		$CollisionShape2D.disabled = true
		await anim_player.animation_finished
		queue_free()
