extends Node2D

@export var score_value := 5


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("score_up"):
		body.score_up(score_value)
	queue_free() # TODO: Disappear animation with AnimationPlayer
